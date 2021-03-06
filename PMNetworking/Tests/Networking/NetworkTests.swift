//
//  NetworkTests.swift
//  ProtonMailTests - Created on 9/17/18.
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

class NetworkTests: XCTestCase {

    override func setUp() {
        HTTPStubs.setEnabled(true)
        HTTPStubs.onStubActivation() { request, descriptor, response in
            // ...
        }
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }

    func testExample() {
        /*let sub = */stub(condition: isHost("www.example.com") && isPath("/1")) { request in
            let body = "{ \"data\": 1 }".data(using: String.Encoding.utf8)!
            let headers = [ "Content-Type" : "application/json"]
            return HTTPStubsResponse(data: body, statusCode: 200, headers: headers)
        }
        
        let expectation1 = self.expectation(description: "Success completion block called")
        let url = URL(string: "https://www.example.com/1")!
        
        
        let manager = AFHTTPSessionManager()
        manager.get(url.absoluteString, parameters: nil, headers: nil, progress: nil, success: { (task, response) -> Void in
            XCTAssertEqual(response as? NSDictionary, [ "data": 1 ])
            //OHHTTPStubs.removeStub(sub)
            expectation1.fulfill()
        }) { (task, error) -> Void in
            XCTFail("This shouldn't return an error")
        }
        
        let expectation2 = self.expectation(description: "Success completion block called")
        manager.get(url.absoluteString, parameters: nil, headers: nil, progress: nil, success: { (task, response) -> Void in
            XCTAssertEqual(response as? NSDictionary, [ "data": 1 ])
            expectation2.fulfill()
        }) { (task, error) -> Void in
            XCTFail("This shouldn't return an error")
        }
        
        self.waitForExpectations(timeout: 1) { (expectationError) -> Void in
            XCTAssertNil(expectationError)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    class DoHMail : DoH, ServerConfig {
        var signupDomain: String = "protonmail.com"
        //defind your default host
        var defaultHost: String = "https://test.protonmail.ch"
        //defind your default captcha host
        var captchaHost: String = "https://api.protonmail.ch"
        //defind your query host
        var apiHost : String = "test.protonpro.xyz"
        //singleton
        static let `default` = try! DoHMail()
        
        override init() throws {
            
        }
    }
    
    func testDefaultSignupDomain() {
        let api : APIService = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID")
        XCTAssertEqual(api.signUpDomain, DoHMail.default.signupDomain)
    }

    func testUserAvailable() {
        /*let sub = */stub(condition: isHost("test.protonmail.ch") && isMethodGET() && isPath("/users/available")) { request in
            var dict = [String:Any]()
            if let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) {
              if let queryItems = components.queryItems {
                for item in queryItems {
                  dict[item.name] = item.value!
                }
              }
            }
            let value = dict["Name"] as! String
            if value == "ok" {
                let body = "{ \"Code\": 1000 }".data(using: String.Encoding.utf8)!
                let headers = [ "Content-Type" : "application/json;charset=utf-8"]
                //            return HTTPStubsResponse(jsonObject: body, statusCode: 200, headers: headers)
                return HTTPStubsResponse(data: body, statusCode: 200, headers: headers)
            }
            let dbody = "{ \"Code\": 1000 }".data(using: String.Encoding.utf8)!
            return HTTPStubsResponse(data: dbody, statusCode: 400, headers: [:])
        }
        let expectation1 = self.expectation(description: "Success completion block called")
        let checkName = UserAPI.Router.checkUsername("ok")
        let api = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID")
        api.exec(route: checkName) { (task, response) in
            XCTAssertEqual(response.code, 1000)
            expectation1.fulfill()
        }

        
        self.waitForExpectations(timeout: 30) { (expectationError) -> Void in
            XCTAssertNil(expectationError)
        }
        
    }
}
