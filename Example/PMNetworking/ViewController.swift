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
        let noAuthService = PMAPIService(doh: DoHMail.default, sessionUID: "unittest100", userID: "unittest100")
        
        ///
        
        
        
        
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
        //
        
    }
    

}

//
//extension ViewController {
//
//}
