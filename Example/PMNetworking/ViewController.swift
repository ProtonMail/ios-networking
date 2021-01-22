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

class DevDoHMail: DoH, ServerConfig {
    //defind your signup domain
    var signupDomain: String = "proton.dev"
    //defind your default host
    var defaultHost: String = "https://proton.dev"
    //defind your default captcha host
    var captchaHost: String = "proton.dev"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //defind your default path
    var defaultPath: String = "/api"
    //singleton
    static let `default` = try! DevDoHMail()
}

class BlueDoHMail: DoH, ServerConfig {
    //defind your signup domain
    var signupDomain: String = "proton.blue"
    //defind your default host
    var defaultHost: String = "https://protonmail.blue"
    //defind your default captcha host
    var captchaHost: String = "mail.protonmail.blue"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //defind your default path
    var defaultPath: String = "/api"
    //singleton
    static let `default` = try! BlueDoHMail()
}

class ProdDoHMail: DoH, ServerConfig {
    //defind your signup domain
    var signupDomain: String = "protonmail.com"
    //defind your default host
    var defaultHost: String = "https://api.protonmail.ch"
    //defind your default captcha host
    var captchaHost: String = "https://api.protonmail.ch"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //singleton
    static let `default` = try! ProdDoHMail()
}


///each user will have one api service  & you can create more than one unauthed apiService
///session/auth data are controlled by a central manager. it needs to extend & implment the API service delegates.

// e.g. we use main view controller as a central manager. it could be any management class instance
class MainViewController: UIViewController {
    @IBOutlet weak var envSegmentedControl: UISegmentedControl!
    
    var testApi = PMAPIService(doh: DevDoHMail.default, sessionUID: "testSessionUID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TrustKitWrapper.start(delegate: self)
        setupEnv()
    }
    
    func setupEnv() {
        testApi = PMAPIService(doh: currentEnv, sessionUID: "testSessionUID")
        // set auth delegate
        testApi.authDelegate = self
        // set service event delegate
        testApi.serviceDelegate = self
    }
    
    var currentEnv: DoH {
        switch envSegmentedControl.selectedSegmentIndex {
        case 0: return DevDoHMail.default
        case 1: return BlueDoHMail.default
        case 2: return ProdDoHMail.default
        default: return DevDoHMail.default
        }
    }
    
    @IBAction func onEnvSegmentedControlTap(_ sender: UISegmentedControl) {
        setupEnv()
    }
    
    @IBAction func authAction(_ sender: Any) {
        getCredentialsAlertView { userName, password in
            self.testFramework(userName: userName, password: password)
        }
    }
    
    @IBAction func forceUpgradeAction(_ sender: Any) {
        forceUpgrade()
    }
    
    @IBAction func humanVerificationAuthAction(_ sender: Any) {
        getCredentialsAlertView { userName, password in
            self.humanVerification(userName: userName, password: password)
        }
    }
    
    @IBAction func humanVerificationUnauthAction(_ sender: Any) {
        self.humanVerification()
    }
    
    /// simulate the cache of auth credential
    var testAuthCredential : AuthCredential? = nil
    
    func testFramework(userName: String, password: String) {
        if self.testAuthCredential != nil {
            self.testAccessToken(userName: userName)
            return
        }
        let authApi: Authenticator = Authenticator(api: testApi)
        authApi.authenticate(username: userName, password: password) { result in
            switch result {
            case .failure(Authenticator.Errors.serverError(let error)): // error response returned by server
                self.showAlertView(title: "Error", message: error.localizedDescription)
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
                self.testAccessToken(userName: userName)
                self.showAlertView(title: "Success")
                break
            case .success(.updatedCredential):
                assert(false, "Should never happen in this flow")
            }
            print(result)
        }
    }
    
    func testAccessToken(userName: String) {
        let request = UserAPI.Router.checkUsername(userName)
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
    
    func setupHumanVerification() {
        testAuthCredential = nil
        currentEnv.status = .off
        testApi.serviceDelegate = self
        testApi.authDelegate = self
        
        //set the human verification delegation
        let url = URL(string: "https://protonmail.com/support/knowledge-base/human-verification/")!
        humanVerificationDelegate = HumanCheckHelper(apiService: testApi, supportURL: url, viewController: self, responseDelegate: self)
        testApi.humanDelegate = humanVerificationDelegate
    }
    
    func humanVerification(userName: String, password: String) {
        setupHumanVerification()
        let authApi: Authenticator = Authenticator(api: testApi)
        authApi.authenticate(username: userName, password: password) { result in
            switch result {
            case .failure(Authenticator.Errors.serverError(let error)): // error response returned by server
                self.showAlertView(title: "Error", message: error.localizedDescription)
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
    
    func humanVerification() {
        setupHumanVerification()
        processHumanVerifyTest()
    }

    func processHumanVerifyTest(dest: String? = nil, type: VerifyMethod? = nil, token: String? = nil) {
        // Human Verify request with empty token just to provoke human verification error
        let client = TestApiClient(api: self.testApi)
        client.triggerHumanVerify(destination: dest, type: type, token: token, isAuth: getToken(bySessionUID: "") != nil) { (_, response) in
            print("Human verify test result: \(response.error?.description as Any)")
        }
    }
    
    var forceUpgradeServiceDelegate: APIServiceDelegate?
    var forceUpgradeDelegate: ForceUpgradeDelegate?
    
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
        return "" //need to be set
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

extension MainViewController {
    func getCredentialsAlertView(result: @escaping ((String, String) -> Void)) {
        var usernameTextField: UITextField?
        var passwordTextField: UITextField?

        let alertController = UIAlertController(title: "Log in", message: "Enter your credentials", preferredStyle: .alert)

        let loginAction = UIAlertAction(title: "Log in", style: .default) { action -> Void in
            result(usernameTextField!.text!, passwordTextField!.text!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addTextField { txtUsername -> Void in
            usernameTextField = txtUsername
            usernameTextField!.placeholder = "Username"
        }
        alertController.addTextField { txtPassword -> Void in
            passwordTextField = txtPassword
            passwordTextField?.isSecureTextEntry = true
            passwordTextField?.placeholder = "Password"
        }
        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertView(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
