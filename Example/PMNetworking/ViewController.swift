//
//  ViewController.swift
//  PMNetworking
//
//  Created on 02/25/2020.
//
//
//  Copyright (c) 2019 Proton Technologies AG
//
//  This file is part of ProtonMail.
//
//  ProtonMail is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  ProtonMail is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with ProtonMail.  If not, see <https://www.gnu.org/licenses/>.

import UIKit
import PMCommon
import PMAuthentication
import Crypto
import PMForceUpgrade
import PMHumanVerification
import PMUICommon

///Defind your doh settings
class DoHMail : DoH, ServerConfig {
    
    var signupDomain: String = "protonmail.com"
    
    //defind your default host
    var defaultHost: String = "https://api.protonmail.ch"
    //defind your default captcha host
    var captchaHost: String = "https://api.protonmail.ch"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //singleton
    static let `default` = try! DoHMail()
}

class TestDoHMail : DoH, ServerConfig {
    var signupDomain: String = "proton.dev"
    
    //defind your default host
//    var defaultHost: String = "https://protonmail.blue"
    var defaultHost: String = "https://proton.dev"
    //defind your default captcha host
//    var captchaHost: String = "mail.protonmail.blue"
    var captchaHost: String = "https://proton.dev"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
        
    var defaultPath: String = "/api"
    
    //singleton
    static let `default` = try! TestDoHMail()
}


///each user will have one api service  & you can create more than one unauthed apiService
///session/auth data are controlled by a central manager. it needs to extend & implment the API service delegates.
let apiService = PMAPIService(doh: DoHMail.default)

// e.g. we use main view controller as a central manager. it could be any management class instance
class MainViewController: UIViewController {
    let testApi = PMAPIService(doh: TestDoHMail.default, sessionUID: "testSessionUID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start a
        TrustKitWrapper.start(delegate: self)
        
        // set auth delegate
        apiService.authDelegate = self
        
        // set service event delegate
        apiService.serviceDelegate = self
    }
    
    @IBAction func authAction(_ sender: Any) {
        self.testFramework()
    }
    
    /// simulate the cache of auth credential
    var authCredential : AuthCredential? = nil
    var testAuthCredential : AuthCredential? = nil
    
    func testFramework() {
        if self.testAuthCredential != nil {
            self.testAccessToken()
            return
        }
        let authApi: Authenticator = Authenticator(api: testApi)
        // blue - user: unittest100, pass: unittest100
        // dev  - user: greg,  pass: a
        authApi.authenticate(username: "greg", password: "a") { result in
            switch result {
            case .failure(Authenticator.Errors.serverError(let error)): // error response returned by server
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
            case .failure(_): // network or parsing error
                print("")
            case .success(.ask2FA(let context)): // success but need 2FA
                print(context)
            case .success(.newCredential(let credential, let passwordMode)): // success without 2FA
                self.testAuthCredential = AuthCredential(credential)
                print("pwd mode: \(passwordMode)")
                self.testAccessToken()
                break
            case .success(.updatedCredential):
                assert(false, "Should never happen in this flow")
            }
            print(result)
        }
    }
    
    func testAccessToken() {
        let request = UserAPI.Router.checkUsername("greg")
        testApi.exec(route: request) { (task, response) in
            print(response.code as Any)
        }
        let request2 = UserAPI.Router.checkUsername("sflkjaslkfjaslkdjf")
        testApi.exec(route: request2) { (task, response) in
            print(response.code as Any)
        }
        let request3 = UserAPI.Router.userInfo
        testApi.exec(route: request3) { (task, response: GetUserInfoResponse) in
            print(response.code as Any)
        }
    }
    
    var humanVerificationDelegate: HumanVerifyDelegate?
    
    @IBAction func humanVerificationAction(_ sender: Any) {
        TestDoHMail.default.status = .off
        testApi.serviceDelegate = self
        testApi.authDelegate = self
        
        //set the human verification delegation
        let url = URL(string: "https://protonmail.com/support/knowledge-base/human-verification/")!
        humanVerificationDelegate = HumanCheckHelper(apiService: testApi, supportURL: url, viewController: self, responseDelegate: self)
        testApi.humanDelegate = humanVerificationDelegate

        let authApi: Authenticator = Authenticator(api: testApi)
        // blue - user: feng2, pass: 123
        // dev  - user: greg,  pass: a
        authApi.authenticate(username: "greg", password: "a") { result in
            switch result {
            case .failure(Authenticator.Errors.serverError(let error)): // error response returned by server
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
            case .failure(_): // network or parsing error
                print("")
            case .success(.ask2FA(let context)): // success but need 2FA
                print(context)
            case .success(.newCredential(let credential, let passwordMode)): // success without 2FA
                self.testAuthCredential = AuthCredential(credential)
                print("pwd mode: \(passwordMode)")
                self.processHumanVerifyTest()
                break
            case .success(.updatedCredential):
                assert(false, "Should never happen in this flow")
            }
            print(result)
        }
    }
    
    func processHumanVerifyTest(dest: String? = nil, type: VerifyMethod? = nil, token: String? = nil) {
        // Human Verify request with empty token just to provoke human verification error
        let client = TestApiClient(api: self.testApi)
        client.triggerHumanVerify(destination: dest, type: type, token: token) { (_, response) in
            print("Human verify test result: \(response.error?.description as Any)")
        }
    }
    
    var forceUpgradeServiceDelegate: APIServiceDelegate?
    var forceUpgradeDelegate: ForceUpgradeDelegate?
    
    @IBAction func forceUpgradeAction(_ sender: Any) {
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
        
        apiService.serviceDelegate = forceUpgradeServiceDelegate
        
        //set the human verification delegation
        let url = URL(string: "itms-apps://itunes.apple.com/app/id979659905")!
        forceUpgradeDelegate = ForceUpgradeHelper(config: .mobile(url), responseDelegate: self)
        apiService.forceUpgradeDelegate = forceUpgradeDelegate
        
        // TODO: update to a PMAuthentication version that depends on PMNetworking
        let authApi: Authenticator = Authenticator(api: apiService)
        authApi.authenticate(username: "feng2", password: "123") { result in
            print (result)
        }
    }
   
    @IBAction func dohUIAction(_ sender: Any) {
        let coordinator = NetworkTroubleShootCoordinator(nav: self.navigationController!,
                                                    services: ServiceFactory.default)
        coordinator.start()
    }
}

extension MainViewController : AuthDelegate {
    
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


extension MainViewController : APIServiceDelegate {
    var userAgent: String? {
        return ""
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

extension MainViewController: TrustKitUIDelegate {
    func onTrustKitValidationError(_ alert: UIAlertController) {
        //pops up error alert
    }
}

extension MainViewController: ForceUpgradeResponseDelegate {
    func onQuitButtonPressed() {
        // on quit button pressed
    }
    
    func onUpdateButtonPressed() {
        // on update button pressed
    }
}

extension MainViewController: HumanVerifyResponseDelegate {
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
