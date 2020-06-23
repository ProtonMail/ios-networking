//
//  AuthAPI.swift
//  PMCommon
//
//  Created by Yanfeng Zhang on 5/22/20.
//
import Foundation

//Auth API
//Doc:https://github.com/ProtonMail/Slim-API/blob/develop/api-spec/pm_api_auth.md
public struct AuthAPI : APIClient {
    /// base message api path
    static let route : String = "/auth"
    
    /// user auth post
    static let v_auth : Int = 3
    /// refresh token post
    static let v_auth_refresh : Int = 3
    /// setup auth info post
    static let v_auth_info : Int = 3
    /// get random srp modulus
    static let v_get_auth_modulus : Int = 3
    /// delete auth
    static let v_delete_auth : Int = 3
    /// revoke other tokens
    static let v_revoke_others : Int = 3
    /// submit 2fa code
    static let v_auth_2fa : Int = 3
    
    
    struct Key {
        static let clientSecret = "ClientSecret"
        static let responseType = "ResponseType"
        static let userName = "Username"
        static let password = "Password"
        static let hashedPassword = "HashedPassword"
        static let grantType = "GrantType"
        static let redirectUrl = "RedirectURI"
        static let scope = "Scope"
        
        static let ephemeral = "ClientEphemeral"
        static let proof = "ClientProof"
        static let session = "SRPSession"
        static let twoFactor = "TwoFactorCode"
    }
    
    public enum Router: Request {
        
        case info(username: String)
        case modulus
        case auth(username: String, ephemeral:String, proof: String, session: String)
        
        public var path: String {
            switch self {
            case .info:
                return route + "/info"
            case .modulus:
                return route + "/modulus"
            case .auth:
                return route
            }
        }
        
        public var header: [String : Any] {
            return [:]
        }
        
        public var method: HTTPMethod {
            switch self {
            case .info, .auth:
                return .post
            case .modulus:
                return .get
            }
        }
        
        public var isAuth: Bool {
            return false
        }
        
        public var parameters: [String: Any]? {
            switch self {
            case .info(let username):
                let out : [String : Any] = [
                    Key.userName : username
                ]
                return out
            case .modulus:
                return nil
            case .auth(let username, let ephemeral, let proof, let session):
                let out : [String : Any] = [
                    Key.userName : username,
                    Key.ephemeral : ephemeral,
                    Key.proof : proof,
                    Key.session : session,
                ]
                return out
            }
        }
    }
}


// MARK : Response part
final public class AuthResponse : Response, CredentialConvertible {
    
    
//    public var accessToken : String?
//    public var expiresIn : TimeInterval?
//    public var refreshToken : String?
    public var sessionID : String?
    public  var eventID : String?
    
//    public var scope : String?
    public var serverProof : String?
    var resetToken : String?
//    var tokenType : String?
    var passwordMode : Int = 0
    
    var userStatus : Int = 0
    
    /// The private key and salt will remove from auth response. need two sperate call to get them
    var privateKey : String?
    var keySalt : String?
    
    var twoFactor : Int = 0
    
//    var isEncryptedToken : Bool {
//        return accessToken?.armored ?? false
//    }
    
    
//    var code: Int
    var accessToken: String = ""
    var expiresIn: TimeInterval = 0.0
    var tokenType: String = ""
    var scope: Scope = ""
    var refreshToken: String = ""
    
    
    override func ParseResponse(_ response: [String : Any]!) -> Bool {
//        self.code = 1000
        
        self.sessionID = response["UID"] as? String //session id
        self.accessToken = response["AccessToken"] as? String ?? ""
        self.expiresIn = response["ExpiresIn"] as? TimeInterval  ?? 0
        self.scope = response["Scope"] as? String ?? ""
        self.eventID = response["EventID"] as? String
        
        self.serverProof = response["ServerProof"] as? String
        self.resetToken = response["ResetToken"] as? String ?? ""
        self.tokenType = response["TokenType"] as? String ?? ""
        self.passwordMode = response["PasswordMode"] as? Int ?? 0
        self.userStatus = response["UserStatus"] as? Int ?? 0
        
        self.privateKey = response["PrivateKey"] as? String
        self.keySalt = response["KeySalt"] as? String
        self.refreshToken = response["RefreshToken"] as? String  ?? ""
        
        if let twoFA = response["2FA"]  as? [String : Any] {
            self.twoFactor = twoFA["Enabled"] as? Int ?? 0
        }
        
        return true
    }
}

final public class AuthInfoResponse : Response {
    public var modulus : String?
    public var serverEphemeral : String?
    public var version : Int = 0
    public var salt : String?
    public var srpSession : String?
    
    override func ParseResponse(_ response: [String : Any]!) -> Bool {
        self.modulus         = response["Modulus"] as? String
        self.serverEphemeral = response["ServerEphemeral"] as? String
        self.version         = response["Version"] as? Int ?? 0
        self.salt            = response["Salt"] as? String
        self.srpSession      = response["SRPSession"] as? String
        return true
    }
}

// use codable
final public class AuthInfoRes : Codable {
    public var Modulus : String?
    public var ServerEphemeral : String?
    public var Version : Int = 0
    public var Salt : String?
    public var SRPSession : String?
    
//    enum CodingKeys: String, CodingKey {
//        case anyProperty
//    }
//    public init(from decoder: Decoder) throws {
//        do {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            if let stringProperty = try? container.decode(String.self, forKey: .anyProperty) {
//                anyProperty = stringProperty
//            } else if let intProperty = try? container.decode(Int.self, forKey: .anyProperty) {
//                anyProperty = intProperty
//            } else {
//                throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Not a JSON"))
//            }
//        }
//    }
}

final public class AuthModulusResponse : Response {
    
    public var Modulus : String?
    public var ModulusID : String?
    
    override func ParseResponse(_ response: [String : Any]!) -> Bool {
        self.Modulus = response["Modulus"] as? String
        self.ModulusID = response["ModulusID"] as? String
        return true
    }
}

//final class TwoFARequest : ApiRequestNew<ApiResponse> {
//
//    var tfacode : String
//    init(api: API, code : String) {
//        self.tfacode = code
//        super.init(api: api)
//    }
//
//    override func toDictionary() -> [String : Any]? {
//        let out : [String : Any] = [
//            "TwoFactorCode": tfacode
//        ]
//        return out
//    }
//
//    override func method() -> HTTPMethod {
//        return .post
//    }
//
//    override func authRetry() -> Bool {
//        return false
//    }
//
//    override func path() -> String {
//        return AuthAPI.path + "/2fa" + Constants.App.DEBUG_OPTION
//    }
//
//    override func apiVersion() -> Int {
//        return AuthAPI.v_auth_2fa
//    }
//}
//
//
//// MARK : refresh token
//final class AuthRefreshRequest : ApiRequest<AuthResponse> {
//
//    var resfreshToken : String
//    var Uid : String
//
//    init(resfresh : String, uid: String) {
//        self.resfreshToken = resfresh
//        self.Uid = uid
//    }
//
//    override func getHeaders() -> [String : Any] {
//        return ["x-pm-uid" :  self.Uid] //TODO:: fixme this shouldn't be here
//    }
//
//    override func toDictionary() -> [String : Any]? {
//        let out : [String : Any] = [
//            "ResponseType": "token",
//            "RefreshToken": resfreshToken,
//            "GrantType": "refresh_token",
//            "RedirectURI" : "http://www.protonmail.ch",
//        ]
//        return out
//    }
//
//    override func method() -> HTTPMethod {
//        return .post
//    }
//
//    override func path() -> String {
//        return AuthAPI.path + "/refresh" + Constants.App.DEBUG_OPTION
//    }
//
//    override func getIsAuthFunction() -> Bool {
//        return false
//    }
//
//    override func apiVersion() -> Int {
//        return AuthAPI.v_auth_refresh
//    }
//}
//
//
//
//// MARK :delete auth token
//final class AuthDeleteRequest : ApiRequest<ApiResponse> {
//
//    override func method() -> HTTPMethod {
//        return .delete
//    }
//
//    override func path() -> String {
//        return AuthAPI.path + Constants.App.DEBUG_OPTION
//    }
//
//    override func getIsAuthFunction() -> Bool {
//        return true
//    }
//
//    override func authRetry() -> Bool {
//        return false
//    }
//
//    override func apiVersion() -> Int {
//        return AuthAPI.v_delete_auth
//    }
//}
//
//


//
//
//
//enum UserRouter: Router {
//
//    case code(type: HumanVerificationToken.TokenType, receiver: String)
//    case check(token: HumanVerificationToken)
//    case checkUsername(String)
//    case createUser(UserProperties)
//
//    var path: String {
//        let base = ApiConstants.baseURL
//        switch self {
//        case .code:
//            return base + "/users/code"
//        case .check:
//            return base + "/users/check"
//        case .checkUsername(let username):
//            return base + "/users/available?Name=" + username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        case .createUser:
//            return base + "/users"
//        }
//    }
//
//    var version: String {
//        switch self {
//        case .code, .check, .checkUsername, .createUser:
//            return "3"
//        }
//    }
//
//    var method: HTTPMethod {
//        switch self {
//        case .checkUsername:
//            return .get
//        case  .code, .createUser:
//            return .post
//        case .check:
//            return .put
//        }
//    }
//
//    var parameters: [String: Any]? {
//        switch self {
//        case .checkUsername:
//            return nil
//        case .code(let type, let receiver):
//            let destinationType: String
//            switch type {
//            case .email:
//                destinationType = "Address"
//            case .sms:
//                destinationType = "Phone"
//            case .payment, .invite, .captcha:
//                fatalError("Wrong parameter used. Payment is not supported by code endpoint.")
//            }
//            return [
//                "Type": type.rawValue,
//                "Destination": [
//                    destinationType: receiver
//                ]
//            ]
//        case .check(let token):
//            return [
//                "Token": "\(token.fullValue)",
//                "TokenType": token.type.rawValue,
//                "Type": vpnType
//            ]
//        case .createUser(let userProperties):
//            var params: [String: Any] = [
//                "Email": userProperties.email,
//                "Username": userProperties.username,
//                "Type": vpnType,
//                "Auth": [
//                    "Version": 4,
//                    "ModulusID": userProperties.modulusID,
//                    "Salt": userProperties.salt,
//                    "Verifier": userProperties.verifier
//                ]
//            ]
//            if let token = userProperties.appleToken {
//                params["Payload"] = [
//                    "higgs-boson": token.base64EncodedString()
//                ]
//            }
//            return params
//        }
//    }
//}
