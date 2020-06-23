//
//  SignInManager.swift
//  PMAuthentication
//
//  Created by Anatoly Rosencrantz on 19/02/2020.
//  Copyright © 2020 ProtonMail. All rights reserved.
//

import Foundation

public protocol SrpAuthProtocol: class {
    init?(_ version: Int, username: String?, password: String?, salt: String?, signedModulus: String?, serverEphemeral: String?)
    func generateProofs(of length: Int) throws -> AnyObject
}

public protocol SrpProofsProtocol: class {
    var clientProof: Data? { get }
    var clientEphemeral: Data? { get }
    var expectedServerProof: Data? { get }
}

public enum PasswordMode: Int, Codable {
    case one = 1, two = 2
}

public class GenericAuthenticator<SRP: SrpAuthProtocol, PROOF: SrpProofsProtocol>: NSObject {
    public typealias Completion = (Result<Status, Error>) -> Void
    
    public enum Status {
        case ask2FA(TwoFactorContext)
        case newCredential(AuthCredential, PasswordMode)
        case updatedCredential(Credential)
    }
    
    public enum Errors: Error {
        case emptyAuthInfoResponse
        case emptyAuthResponse
        case emptyServerSrpAuth
        case emptyClientSrpAuth
        case wrongServerProof
        case serverError(NSError)

        case notImplementedYet(String)
    }
    
    public struct Configuration {
        public init(trust: TrustChallenge?,
                    scheme: String,
                    host: String,
                    apiPath: String,
                    clientVersion: String)
        {
            self.trust = trust
            self.scheme = scheme
            self.host = host
            self.apiPath = apiPath
            self.clientVersion = clientVersion
        }

        var trust: TrustChallenge?
        var scheme: String
        var host: String
        var apiPath: String
        var clientVersion: String
    }
    
//    private weak var trustInterceptor: SessionDelegate? // weak because URLSession holds a strong reference to delegate
//    private lazy var session: URLSession = {
//        let config = URLSessionConfiguration.default
//        let delegate = SessionDelegate()
//        let session = URLSession(configuration: config, delegate: delegate, delegateQueue: nil)
//        self.trustInterceptor = delegate
//        return session
//    }()
    
    
    
    
//    public convenience init(api: APIService) {
//        self.init()
//        self.update(apiService: api)
//    }
//    
    public convenience init(api: APIService) {
        self.init()
//        self.update(configuration: configuration)
        self.apiService = api
    }
    
    // we do not want this to be ever used
    override private init() { }
    
//    deinit {
//        self.session.finishTasksAndInvalidate()
//    }
    
    private var apiService : APIService!
    
//    public override init() {
//        super.init()
//    }
//    
//    public func update(apiService: APIService) {
//        self.apiService = apiService
////        AuthService.trust = configuration.trust
////        AuthService.scheme = configuration.scheme
////        AuthService.host = configuration.host
////        AuthService.apiPath = configuration.apiPath
////        AuthService.clientVersion = configuration.clientVersion
//
//    }

    public func update(configuration: Configuration) {
        AuthService.trust = configuration.trust
        AuthService.scheme = configuration.scheme
        AuthService.host = configuration.host
        AuthService.apiPath = configuration.apiPath
        AuthService.clientVersion = configuration.clientVersion
    }
    
    /// Clear login, when preiously unauthenticated
    public func authenticate(username: String,
                             password: String,
                             completion: @escaping Completion)
    {
        // 1. auth info request
        //let authInfoEndpoint = AuthService.InfoEndpoint(username: username)
        let authInfoEndpoint = AuthAPI.Router.info(username: username)
        self.apiService.exec(route: authInfoEndpoint) { (task, response: AuthInfoResponse) in
            guard response.error == nil else {
                return completion(.failure(response.error!))
            }
                        
            // 2. build SRP things
            do {
                guard let auth = SRP(response.version,
                                     username: username,
                                     password: password,
                                     salt: response.salt,
                                     signedModulus: response.modulus,
                                     serverEphemeral: response.serverEphemeral) else
                {
                    throw Errors.emptyServerSrpAuth
                }
                
                // client SRP
                let srpClient = try auth.generateProofs(of: 2048) as! PROOF
                guard let clientEphemeral = srpClient.clientEphemeral,
                    let clientProof = srpClient.clientProof,
                    let expectedServerProof = srpClient.expectedServerProof else
                {
                    throw Errors.emptyClientSrpAuth
                }
                
                // 3. auth request
                
                let authEndpoint = AuthAPI.Router.auth(username: username,
                                                       ephemeral: clientEphemeral.base64EncodedString(),
                                                       proof: clientProof.base64EncodedString(),
                                                       session: response.srpSession ?? "")
                self.apiService.exec(route: authEndpoint) { (task, response: AuthResponse) in
                    guard response.error == nil else {
                        return completion(.failure(response.error!))
                    }
     
                    do {                        
                        // are we done yet or need 2FA?
                        if response.twoFactor == 1 {
                            let context = (Credential(res: response), PasswordMode(rawValue: response.passwordMode)!)
                            completion(.success(.ask2FA(context)))
                        } else {
//                            let credential = Credential(res: response)
                            
                            let credential = AuthCredential(res: response)
                            completion(.success(.newCredential(credential, PasswordMode(rawValue: response.passwordMode)!)))
                        }
//                        switch response.twoFactor {
//                        case .off:
//                            let credential = Credential(res: response)
//                            completion(.success(.newCredential(credential, response.passwordMode)))
//                        case .on:
//                            let context = (Credential(res: response), response.passwordMode)
//                            completion(.success(.ask2FA(context)))
//
//                        case .u2f, .otp:
//                            throw Errors.notImplementedYet("U2F not implemented yet")
//                        }
                        
                    } catch let parsingError {
                        completion(.failure(parsingError))
                    }
                }
            } catch let parsingError {
                return completion(.failure(parsingError))
            }
        }
        
//        self.session.dataTask(with: authInfoEndpoint.request) { responseData, response, networkingError in
//            guard networkingError == nil else {
//                return completion(.failure(networkingError!))
//            }
//            guard let responseData = responseData else {
//                return completion(.failure(Errors.emptyAuthInfoResponse))
//            }
//        }.resume()
    }
    
    /// Continue clear login flow with 2FA code
    public func confirm2FA(_ twoFactorCode: Int,
                           context: TwoFactorContext,
                           completion: @escaping Completion)
    {
        let twoFAEndpoint = AuthService.TwoFAEndpoint(code: twoFactorCode, token: context.credential.accessToken, UID: context.credential.UID)
//        self.session.dataTask(with: twoFAEndpoint.request) { responseData, response, networkingError in
//            guard networkingError == nil else {
//                return completion(.failure(networkingError!))
//            }
//            guard let responseData = responseData else {
//                return completion(.failure(Errors.emptyAuthResponse))
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .decapitaliseFirstLetter
//
//                // server error code
//                if let error = try? decoder.decode(ErrorResponse.self, from: responseData) {
//                    throw Errors.serverError(NSError(error))
//                }
//
//                let response = try decoder.decode(AuthService.TwoFAEndpoint.Response.self, from: responseData)
//
//                var credential = context.credential
//                credential.updateScope(response.scope)
//                completion(.success(.newCredential(credential, context.passwordMode)))
//
//            } catch let parsingError {
//                completion(.failure(parsingError))
//            }
//        }.resume()
    }
    
    // Refresh expired access token using refresh token
    public func refreshCredential(_ oldCredential: Credential,
                                  completion: @escaping Completion)
    {
        let refreshEndpoint = AuthService.RefreshEndpoint(refreshToken: oldCredential.refreshToken, UID: oldCredential.UID)
//        self.session.dataTask(with: refreshEndpoint.request) { responseData, response, networkingError in
//            guard networkingError == nil else {
//                return completion(.failure(networkingError!))
//            }
//            guard let responseData = responseData else {
//                return completion(.failure(Errors.emptyAuthResponse))
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .decapitaliseFirstLetter
//                
//                // server error code
//                if let error = try? decoder.decode(ErrorResponse.self, from: responseData) {
//                    throw Errors.serverError(NSError(error))
//                }
//                
//                let response = try decoder.decode(AuthService.RefreshEndpoint.Response.self, from: responseData)
//
//                // refresh endpoint does not return UID in the response, so we have to inject old one manually
//                let credential = Credential(res: response, UID: oldCredential.UID)
//                completion(.success(.updatedCredential(credential)))
//                
//            } catch let parsingError {
//                completion(.failure(parsingError))
//            }
//        }.resume()
    }
}

public typealias TrustChallenge = (URLSession, URLAuthenticationChallenge, @escaping URLSessionDelegateCompletion) -> Void
public typealias URLSessionDelegateCompletion = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void

// Point to inject TrustKit
//class SessionDelegate: NSObject, URLSessionDelegate {
//    public func urlSession(_ session: URLSession,
//                           didReceive challenge: URLAuthenticationChallenge,
//                           completionHandler: @escaping URLSessionDelegateCompletion)
//    {
//        if let trust = AuthService.trust {
//            trust(session, challenge, completionHandler)
//        } else {
//            completionHandler(.performDefaultHandling, nil)
//        }
//    }
//}



extension Credential {
    public init(_ authCredential: AuthCredential) {
        self.init(UID: authCredential.sessionID,
                  accessToken: authCredential.accessToken,
                  refreshToken: authCredential.refreshToken,
                  expiration: authCredential.expiration,
                  scope: [])
    }
}
extension AuthCredential {
    public convenience init(_ credential: Credential) {
        self.init(sessionID: credential.UID,
                  accessToken: credential.accessToken,
                  refreshToken: credential.refreshToken,
                  expiration: credential.expiration,
                  privateKey: nil,
                  passwordKeySalt: nil)
    }
}
