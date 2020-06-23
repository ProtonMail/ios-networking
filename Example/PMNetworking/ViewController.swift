//
//  ViewController.swift
//  PMNetworking
//
//  Created by zhj4478 on 02/25/2020.
//  Copyright (c) 2020 zhj4478. All rights reserved.
//

import UIKit
import PMCommon
import Crypto

class DoHMail : DoH, DoHConfig {
    //defind your default host
    var defaultHost: String = "https://api.protonmail.ch"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //singleton
    static let `default` = try! DoHMail()
}


class MainViewController: UIViewController {
    
    let apiService = PMAPIService(doh: DoHMail.default, sessionUID: "unittest100", userID: "unittest100")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.authDelegate = self
        apiService.serviceDelegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testButton(_ sender: Any) {
        self.testFramework()

    }
    
    var authCredential : AuthCredential? = nil
    
    func testFramework() {

        if self.authCredential != nil {
            self.testAccessToken()
            return
        }
        
        let authApi: Authenticator = {
            let trust: TrustChallenge = { session, challenge, completion in
                //                if let validator = TrustKitWrapper.current?.pinningValidator {
                //                    validator.handle(challenge, completionHandler: completion)
                //                } else {
                //                    assert(false, "TrustKit was not initialized properly")
                completion(.performDefaultHandling, nil)
                //                }
            }
//
            let configuration = Authenticator.Configuration(trust: trust,
                                                            scheme: "https",
                                                            host: "api.protonmail.ch",
                                                            apiPath: "",
                                                            clientVersion: "iOS_1.12.0")
            return Authenticator(api: apiService)
        }()
        
        authApi.authenticate(username: "unittest100", password: "unittest100") { result in
            switch result {
            case .failure(Authenticator.Errors.serverError(let error)): // error response returned by server
                //                return completion(nil, .resCheck, nil, nil, nil, error)
                print(error)
            case .failure(Authenticator.Errors.emptyServerSrpAuth):
                //                return completion(nil, .resCheck, nil, nil, nil, NSError.authUnableToGeneratePwd())
                print("")
            case .failure(Authenticator.Errors.emptyClientSrpAuth):
                //                return completion(nil, .resCheck, nil, nil, nil, NSError.authUnableToGenerateSRP())
                print("")
            case .failure(Authenticator.Errors.wrongServerProof):
                //                return completion(nil, .resCheck, nil, nil, nil, NSError.authServerSRPInValid())
                print("")
            case .failure(Authenticator.Errors.emptyAuthResponse):
                //                return completion(nil, .resCheck, nil, nil, nil, NSError.authUnableToParseToken())
                print("")
            case .failure(Authenticator.Errors.emptyAuthInfoResponse):
                //                return completion(nil, .resCheck, nil, nil, nil, NSError.authUnableToParseAuthInfo())
                print("")
            case .failure(_): // network or parsing error
                //                return completion(nil, .resCheck, nil, nil, nil, NSError.internetError())
                print("")
            case .success(.ask2FA(let context)): // success but need 2FA
                //                return completion(nil, .ask2FA, nil, context, nil, nil)
                print("")
            case .success(.newCredential(let credential, let passwordMode)): // success without 2FA
                self.authCredential = AuthCredential(credential)
                
                
                self.testAccessToken()
                break
            case .success(.updatedCredential):
                assert(false, "Should never happen in this flow")
            }
            print(result)
        }
    }
    
    func testAccessToken() {
        //
//        let request = UserAPI.Router.checkUsername("unittest100")
//        apiService.exec(route: request) { (task, response) in
//            print(response.code)
//        }
//        let request2 = UserAPI.Router.checkUsername("sflkjaslkfjaslkdjf")
//        apiService.exec(route: request2) { (task, response) in
//            print(response.code)
//        }
//
        let request3 = UserAPI.Router.userInfo
        apiService.exec(route: request3) { (task, response: GetUserInfoResponse) in
            print(response.code)
        }
    }
    
    func testHumanVerify() {
        // setup the mock
        
        // make a fake call to trigger the human verify
        
        //
    }
    

}


extension MainViewController : AuthDelegate {
    func getToken(bySessionUID uid: String) -> AuthCredential? {
        return authCredential
//        return nil //get cached AuthCredential
    }
    
    func onUpdate(auth: AuthCredential) {
        
    }
    
    func onLogout() {
        
    }
    
    func onRevoke() {
        
    }
    
    func onRefresh() {
        
    }
    

}


extension MainViewController : APIServiceDelegate {
    func onUpdate(serverTime: Int64) {
        
    }
    
    func onChallenge() {
        
    }
    
    func onDohTroubleshot() {
        
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
