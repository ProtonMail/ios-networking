//
//  ViewController.swift
//  PMNetworking
//
//  Created by zhj4478 on 02/25/2020.
//  Copyright (c) 2020 zhj4478. All rights reserved.
//

import UIKit
import PMCommon


class DoHMail : DoH, DoHConfig {
    //defind your default host
    var defaultHost: String = "https://api.protonmail.ch"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //singleton
    static let `default` = try! DoHMail()
}


class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testButton(_ sender: Any) {
        self.testFramework()
    }
    
    func testFramework() {

        let authApi: Authenticator = {
            let trust: TrustChallenge = { session, challenge, completion in
//                if let validator = TrustKitWrapper.current?.pinningValidator {
//                    validator.handle(challenge, completionHandler: completion)
//                } else {
//                    assert(false, "TrustKit was not initialized properly")
                    completion(.performDefaultHandling, nil)
//                }
            }
            
            let configuration = Authenticator.Configuration(trust: trust,
                                                            scheme: "https",
                                                            host: "api.protonmail.ch",
                                                            apiPath: "",
                                                            clientVersion: "iOS_1.12.0")
            return Authenticator(configuration: configuration)
        }()
        
        //let expectation1 = self.expectation(description: "Success completion block called")
        //let authOK = AuthAPI.Router.auth(username: "ok", ephemeral: "", proof: "", session: "")
        //api.exec(route: authOK) { (task, response: AuthResponse) in
        //                    XCTAssertEqual(response.code, 1000)
        //        //            XCTAssert(response.error == nil)
        //        //            XCTAssertTrue(response != nil)
        //        //            XCTAssertTrue(response.ModulusIDpublic == "Oq_JB_IkrOx5WlpxzlRPocN3_NhJ80V7DGav77eRtSDkOtLxW2jfI3nUpEqANGpboOyN-GuzEFXadlpxgVp7_g==")
        //                    expectation1.fulfill()
        //                }
        //                self.waitForExpectations(timeout: 30) { (expectationError) -> Void in
        //                    XCTAssertNil(expectationError)
        //                }
        
        
        
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
//                let authCredential = AuthCredential(credential)
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
        let apiService = PMAPIService(doh: DoHMail.default, sessionUID: "unittest100", userID: "unittest100")
        apiService.authDelegate = self
        apiService.serviceDelegate = self
        let request = UserAPI.Router.checkUsername("unittest100")
        
        apiService.exec(route: request) { (task, response) in
            
        }
        
        
    }
    

}


extension MainViewController : AuthDelegate {
    func getToken(bySessionUID uid: String) -> AuthCredential? {
        return nil //get cached AuthCredential
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
        
    }
}
