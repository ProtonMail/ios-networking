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
import Crypto

///Defind your doh settings
class DoHMail : DoH, DoHConfig {
    //defind your default host
    var defaultHost: String = "https://api.protonmail.ch"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //singleton
    static let `default` = try! DoHMail()
}


///each user will have one api service  & you can create more than one unauthed apiService
///session/auth data are controlled by a central manager. it needs to extend & implment the API service delegates.
let apiService = PMAPIService(doh: DoHMail.default)

// e.g. we use main view controller as a central manager. it could be any management class instance
class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // start a
         TrustKitWrapper.start(delegate: self)
        
        //set auth delegate
        apiService.authDelegate = self
        
        // set service event delegate
        apiService.serviceDelegate = self
    }
    
    @IBAction func testButton(_ sender: Any) {
        self.testFramework()

    }
    
    /// simulate the cache of auth credential
    var authCredential : AuthCredential? = nil
    
    func testFramework() {
        if self.authCredential != nil {
            self.testAccessToken()
            return
        }
        
        let authApi: Authenticator = {
            let configuration = Authenticator.Configuration(scheme: "https",
                                                            host: "api.protonmail.ch",
                                                            apiPath: "",
                                                            clientVersion: "iOS_1.12.0")
            return Authenticator(api: apiService)
        }()
        
        authApi.authenticate(username: "unittest100", password: "unittest100") { result in
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
                self.authCredential = credential
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
        let request = UserAPI.Router.checkUsername("unittest100")
        apiService.exec(route: request) { (task, response) in
            print(response.code as Any)
        }
        let request2 = UserAPI.Router.checkUsername("sflkjaslkfjaslkdjf")
        apiService.exec(route: request2) { (task, response) in
            print(response.code as Any)
        }
        let request3 = UserAPI.Router.userInfo
        apiService.exec(route: request3) { (task, response: GetUserInfoResponse) in
            print(response.code as Any)
            self.testHumanVerify()
        }
    }
    
    func testHumanVerify() {
        // setup the mock
        // make a fake call to trigger the human verify
        
        DispatchQueue.main.async {
            self.onHumanVerify()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainViewController : AuthDelegate {
    func getToken(bySessionUID uid: String) -> AuthCredential? {
        print("looking for auth UID: " + uid)
        print("compare cache with index: \(uid == authCredential?.sessionID ?? "") ")
        return authCredential
    }
    
    func onUpdate(auth: AuthCredential) {
        /// update your local cache
    }
    
    func onLogout() {
        //
    }
    
    func onRevoke() {
        //
    }
    
    func onRefresh() {
        //
    }
}


extension MainViewController : APIServiceDelegate {
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
    
    func onHumanVerify() {
        let bundle = Bundle(for: HumanCheckMenuViewController.self)
        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: bundle)
        guard let customViewController = storyboard.instantiateViewController(withIdentifier: "HumanCheckMenuViewController") as? HumanCheckMenuViewController else {
            print("bad")
            return
        }
        self.navigationController?.pushViewController(customViewController, animated: true)
    }
}

extension MainViewController: TrustKitUIDelegate {
    func onTrustKitValidationError(_ alert: UIAlertController) {
        //pops up error alert
        
    }
}
