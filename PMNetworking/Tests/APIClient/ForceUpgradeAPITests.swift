//
//  ForceUpgradeAPITests.swift
//  ProtonMailTests - Created on 13/11/20.
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


import XCTest

import OHHTTPStubs
import AFNetworking
import PMCommon

class ForceUpgradeAPITests: XCTestCase {
    
    override func setUp() {
        HTTPStubs.setEnabled(true)
        HTTPStubs.onStubActivation() { request, descriptor, response in }
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }
    
    // Test configuration
    
    class DoHMail: DoH, ServerConfig {
        var signupDomain: String = "protonmail.blue"
        //defind your default host
        var defaultHost: String = "https://protonmail.blue"
        //defind your default captcha host
        var captchaHost: String = "https://api.protonmail.ch"
        //defind your query host
        var apiHost : String = "test.protonpro.xyz"
        var defaultPath: String = "/api"
        //singleton
        static let `default` = try! DoHMail()
        override init() throws {
            
        }
    }
    
    class TestAuthDelegate: AuthDelegate {
        func onForceUpgrade() { }
        var authCredential: AuthCredential?
        func getToken(bySessionUID uid: String) -> AuthCredential? { return nil }
        func onLogout(sessionUID uid: String) { }
        func onUpdate(auth: Credential) { }
        func onRevoke(sessionUID uid: String) { }
        func onRefresh(bySessionUID uid: String, complete: (Credential?, NSError?) -> Void) { }
    }
    
    class TestAPIServiceDelegate: APIServiceDelegate {
        func isReachable() -> Bool { return true }
        var userAgent: String? { return "" }
        func onUpdate(serverTime: Int64) { }
        var appVersion: String { return "iOS_0.0.1" }
        func onDohTroubleshot() { }
        func onHumanVerify() { }
        func onChallenge(challenge: URLAuthenticationChallenge, credential: AutoreleasingUnsafeMutablePointer<URLCredential?>?) -> URLSession.AuthChallengeDisposition {
            return .useCredential
        }
    }
    
    func testBadAppVersion() {
        // backend answer when there is no verification token
        stub(condition: isHost("protonmail.blue") && isMethodPOST() && isPath("/api/auth/info")) { request in
            let responseString = "{\"Error\": \"This version of the app is no longer supported, please update from the App Store to continue using it\",\"Code\": 5003}"
            let body = responseString.data(using: String.Encoding.utf8)!
            let headers = ["Content-Type" : "application/json;charset=utf-8"]
            return HTTPStubsResponse(data: body, statusCode: 200, headers: headers)
        }
        
        let expectation = self.expectation(description: "Success completion block called")
        let api = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID")
        let testAPIServiceDelegate = TestAPIServiceDelegate()
        api.serviceDelegate = testAPIServiceDelegate
        let authInfoOK = AuthAPI.Router.info(username: "user1")
        api.exec(route: authInfoOK) { (task, response: AuthInfoResponse) in
            XCTAssertEqual(response.code, 5003)
            XCTAssert(response.error != nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (expectationError) -> Void in
            XCTAssertNil(expectationError)
        }
    }
    
    func testBadApiVersion() {
        // backend answer when there is no verification token
        stub(condition: isHost("protonmail.blue") && isMethodPOST() && isPath("/api/auth/info")) { request in
            let responseString = "{\"Error\": \"This version of the api is no longer supported, please update from the App Store to continue using it\",\"Code\": 5005}"
            let body = responseString.data(using: String.Encoding.utf8)!
            let headers = ["Content-Type" : "application/json;charset=utf-8"]
            return HTTPStubsResponse(data: body, statusCode: 200, headers: headers)
        }
        
        let expectation = self.expectation(description: "Success completion block called")
        let api = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID")
        let testAPIServiceDelegate = TestAPIServiceDelegate()
        api.serviceDelegate = testAPIServiceDelegate
        let authInfoOK = AuthAPI.Router.info(username: "user1")
        api.exec(route: authInfoOK) { (task, response: AuthInfoResponse) in
            XCTAssertEqual(response.code, 5005)
            XCTAssert(response.error != nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1) { (expectationError) -> Void in
            XCTAssertNil(expectationError)
        }
    }


}
