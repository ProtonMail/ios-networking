//
//  NetworkingViewModel.swift
//  PMNetworking_SwiftUI_Example
//
//  Created by Greg on 22.01.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
import PMCommon
import PMAuthentication
import PMForceUpgrade
import PMHumanVerification

class DevDoHMail: DoH, ServerConfig {
    var signupDomain: String = "proton.dev"
    var defaultHost: String = "https://proton.dev"
    var captchaHost: String = "proton.dev"
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    var defaultPath: String = "/api"
    static let `default` = try! DevDoHMail()
}

class BlueDoHMail: DoH, ServerConfig {
    var signupDomain: String = "proton.blue"
    var defaultHost: String = "https://protonmail.blue"
    var captchaHost: String = "mail.protonmail.blue"
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    var defaultPath: String = "/api"
    static let `default` = try! BlueDoHMail()
}

class ProdDoHMail: DoH, ServerConfig {
    var signupDomain: String = "protonmail.com"
    var defaultHost: String = "https://api.protonmail.ch"
    var captchaHost: String = "https://api.protonmail.ch"
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    static let `default` = try! ProdDoHMail()
}

class NetworkingViewModel: ObservableObject {

    var testApi = PMAPIService(doh: DevDoHMail.default, sessionUID: "testSessionUID")
    var testAuthCredential : AuthCredential? = nil
    var humanVerificationDelegate: HumanVerifyDelegate?

    init() {
        TrustKitWrapper.start(delegate: self)
        setupEnv()
    }
    
    var env = ["Dev env.", "Blue env.", "Prod env."]
    var selectedIndex: Int = 0 { didSet { setupEnv() } }
    
    func setupEnv() {
        testApi = PMAPIService(doh: currentEnv, sessionUID: "testSessionUID")
        testApi.authDelegate = self
        testApi.serviceDelegate = self
    }
    
    var currentEnv: DoH {
        switch selectedIndex {
        case 0: return DevDoHMail.default
        case 1: return BlueDoHMail.default
        case 2: return ProdDoHMail.default
        default: return DevDoHMail.default
        }
    }
    
    func authAction() {
        auth(userName: "greg", password: "a")
    }

    func humanVerificationUnauthAction() {
        setupHumanVerification()
        processHumanVerifyTest()
    }

    func forceUpgradeAction() {
        forceUpgrade()
    }
    
    func forceUpgrade() {
        forceUpgradeServiceDelegate = {
            class TestDelegate: APIServiceDelegate {
                var userAgent: String? = ""
                func onUpdate(serverTime: Int64) {}
                func isReachable() -> Bool { return true }
                var appVersion: String = "iOS_0.0.1"
                func onDohTroubleshot() {}
                func onChallenge(challenge: URLAuthenticationChallenge, credential: AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition {
                    return .performDefaultHandling
                }
            }
            return TestDelegate()
        }()
        
        testApi.serviceDelegate = forceUpgradeServiceDelegate
        
        //set the human verification delegation
        let url = URL(string: "itms-apps://itunes.apple.com/app/id979659905")!
        forceUpgradeDelegate = ForceUpgradeHelper(config: .mobile(url), responseDelegate: self)
        testApi.forceUpgradeDelegate = forceUpgradeDelegate
        
        // TODO: update to a PMAuthentication version that depends on PMNetworking
        let authApi: Authenticator = Authenticator(api: testApi)
        authApi.authenticate(username: "test", password: "test") { result in
            print (result)
        }
    }
    
    var forceUpgradeServiceDelegate: APIServiceDelegate?
    var forceUpgradeDelegate: ForceUpgradeDelegate?
    
    func setupHumanVerification() {
        testAuthCredential = nil
        currentEnv.status = .off
        testApi.serviceDelegate = self
        testApi.authDelegate = self

        //set the human verification delegation
        let url = URL(string: "https://protonmail.com/support/knowledge-base/human-verification/")!
        humanVerificationDelegate = HumanCheckHelper(apiService: testApi, supportURL: url, viewController: nil, responseDelegate: self)
        testApi.humanDelegate = humanVerificationDelegate
    }

    func processHumanVerifyTest(dest: String? = nil, type: VerifyMethod? = nil, token: String? = nil) {
        // Human Verify request with empty token just to provoke human verification error
        let client = TestApiClient(api: self.testApi)
        client.triggerHumanVerify(destination: dest, type: type, token: token, isAuth: getToken(bySessionUID: "") != nil) { (_, response) in
            print("Human verify test result: \(response.error?.description as Any)")
        }
    }
    
    func auth(userName: String, password: String) {
        currentEnv.status = .off
        let authApi: Authenticator = Authenticator(api: testApi)
        authApi.authenticate(username: userName, password: password) { result in
            switch result {
            case .failure(Authenticator.Errors.serverError(let error)): // error response returned by server
//                self.showAlertView(title: "Error", message: error.localizedDescription)
                print(error)
            case .failure(Authenticator.Errors.emptyServerSrpAuth):
                print("")
            case .failure(Authenticator.Errors.emptyClientSrpAuth):
                print("")
            case .failure(Authenticator.Errors.wrongServerProof):
                print("")
            case .failure(Authenticator.Errors.emptyAuthResponse):
                print("")
            case .failure(Authenticator.Errors.emptyAuthInfoResponse):
                print("")
            case .failure(let error): // network or parsing error
                print(error)
            case .success(.ask2FA(let context)): // success but need 2FA
                print(context)
            case .success(.newCredential(let credential, let passwordMode)): // success without 2FA
                self.testAuthCredential = AuthCredential(credential)
                print("pwd mode: \(passwordMode)")
//                self.showAlertView(title: "Success")
                break
            case .success(.updatedCredential):
                assert(false, "Should never happen in this flow")
            }
            print(result)
        }
    }

    
}

extension NetworkingViewModel: AuthDelegate {

    func onRefresh(bySessionUID uid: String, complete: (Credential?, NSError?) -> Void) {
        // must call complete - later will have a middle layer manager to handle this because all plantforms will be sharee the same logic

        //steps:
        // - find auth by uid
        // - double check if the auth ok
        // - call refresh token
        // - pass result to complete
    }

    func getToken(bySessionUID uid: String) -> AuthCredential? {
        print("looking for auth UID: " + uid)
        print("compare cache with index: \(uid == testAuthCredential?.sessionID ?? "") ")
        return self.testAuthCredential
    }

    func onUpdate(auth: Credential) {
        /// update your local cache
    }

    // right now the logout and revoke do the same but they triggered by a different event. will try to unify this.
    func onLogout(sessionUID uid: String) {
        //try to logout this user by uid
    }

    func onForceUpgrade() {
        //
    }
}

extension NetworkingViewModel: APIServiceDelegate {
    var userAgent: String? {
        return ""//need to be set
    }

    func isReachable() -> Bool {
        return true
    }


    var appVersion: String {
        return "iOS_\(Bundle.main.majorVersion)"
    }

    func onChallenge(challenge: URLAuthenticationChallenge,
                     credential: AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition {

        var dispositionToReturn: URLSession.AuthChallengeDisposition = .performDefaultHandling
        if let validator = TrustKitWrapper.current?.pinningValidator {
            validator.handle(challenge, completionHandler: { (disposition, credentialOut) in
                credential?.pointee = credentialOut
                dispositionToReturn = disposition
            })
        } else {
            assert(false, "TrustKit not initialized correctly")
        }

        return dispositionToReturn
    }

    func onUpdate(serverTime: Int64) {
        // on update the server time for user.
    }

    func onChallenge() {
        // on cert pinning challenge
    }

    func onDohTroubleshot() {
        // show up Doh Troubleshot view
    }
}

extension NetworkingViewModel: TrustKitUIDelegate {
    func onTrustKitValidationError(_ alert: UIAlertController) {
        //pops up error alert
    }
}

extension NetworkingViewModel: ForceUpgradeResponseDelegate {
    func onQuitButtonPressed() {
        // on quit button pressed
    }

    func onUpdateButtonPressed() {
        // on update button pressed
    }
}

extension NetworkingViewModel: HumanVerifyResponseDelegate {
    func onHumanVerifyStart() {
        print ("Human verify start")
    }

    func onHumanVerifyEnd(result: HumanVerifyEndResult) {
        switch result {
        case .success:
            print ("Human verify success")
        case .cancel:
            print ("Human verify cancel")
        }
    }
}
