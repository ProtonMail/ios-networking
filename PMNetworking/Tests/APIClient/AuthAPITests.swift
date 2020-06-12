//
//  UserAPITests.swift
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

class AuthAPITests: XCTestCase {
    
    class DoHMail : DoH, DoHConfig {
        //defind your default host
        var defaultHost: String = "https://test.protonmail.ch"
        //defind your query host
        var apiHost : String = "test.protonpro.xyz"
        //singleton
        static let `default` = try! DoHMail()
        
        override init() throws {
            
        }
    }

    override func setUp() {
        HTTPStubs.setEnabled(true)
        HTTPStubs.onStubActivation() { request, descriptor, response in
            // ...
        }
        stub(condition: isHost("test.protonmail.ch") && isMethodGET() && isPath("/auth/info")) { request in
            var dict = [String:Any]()
            if let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false) {
                if let queryItems = components.queryItems {
                    for item in queryItems {
                        dict[item.name] = item.value!
                    }
                }
            }
            
            let ok = "{\"Code\":1000,\"Modulus\":\"-----BEGIN PGP SIGNED MESSAGE-----\\nHash: SHA256\\n\\nG3q3Mjx9qo2dJsZKSuyiLIFUDKhHHUjdtCuxZGUrs0oGHDYSKNnL83w62ho2NSxRnFuzaI4htsIsDyeUV4Me4PUpw22xt6RLIuyGvx6lcJDaxtARF/SoS0CMpWmcITGe9B+1imOcjN4xYjct9ATwHaQwTWb03YMMLTSsbYcaE0mJ9rOVnanaT0XQIyAve6I5vWfTkDUrtZQMQFM1rWe3PuW9BZQMEJ/FITYDzZWcnBEEUrvQwKFXHgiu1SmkPMzx6SJjNkebCkhZJhKfeSo2NuYlYIi/uff6dRTmhPqtQXWzTcYQov0P5u7i5b5as98kwtg2LK2/Ooeu5m9IoAYYqg==\\n-----BEGIN PGP SIGNATURE-----\\nVersion: ProtonMail\\nComment: https://protonmail.com\\n\\nwl4EARYIABAFAlwB1j0JEDUFhcTpUY8mAACvlAEA+Psf6LHuQSrXI0vlPuue\\nFkiHEvkyJJaY3xLvnM63JjIBAOumYlk2+D5Y6apeLWD1mHbM9MTmWZtDrI/2\\n1tOfGMkB\\n=oj+8\\n-----END PGP SIGNATURE-----\\n\",\"ServerEphemeral\":\"RXrpmW8TixDVQw3OJg0QfC5dscIcZ/Bp+rRPMLhCK9dNJLidBj9MmiZRkVdQxVx+5NDgvDyt0IzwkVnRrTjLUHvftHMgdzAG5wD9yZch5zKB1YlDy3ZirHqlWjWD5luKrOwlxAvzBPUZGKfnSb4laKRNTwwQnUPat+rVZHerGckWK1OdoG2vPaQZiPvaXxQZnSZ099ATE5Jcv/iUBXFhNpLPWXQ5r/phGFDDwy6sWLOUPHDDIjsVII6mnDL9G2p+/RonYcy05rwEWxmSzGGwW3kaC9IglpGxD+MR/dOv2ToGFnxOJQUSKZ6ZGzEg913fL0b+4afbq+rrDZgKUNl9VQ==\",\"Version\":4,\"Salt\":\"0cNmaaFTYxDdFA==\",\"SRPSession\":\"b7953c6a26d97a8f7a673afb79e6e9ce\"}"
            let value = dict["Username"] as! String
            if value == "ok" {
                let body = ok.data(using: String.Encoding.utf8)!
                let headers = [ "Content-Type" : "application/json;charset=utf-8"]
                return HTTPStubsResponse(data: body, statusCode: 200, headers: headers)
            } else if value == "InvalidCharacters" {
                let body = "{ \"Code\": 12102, \"Error\": \"Invalid characters\", \"Details\": {} }".data(using: String.Encoding.utf8)!
                let headers = [ "Content-Type" : "application/json;charset=utf-8"]
                return HTTPStubsResponse(data: body, statusCode: 400, headers: headers)
            } else if value == "StartSpecialCharacter" {
                let body = "{ \"Code\": 12103, \"Error\": \"Username start with special character\", \"Details\": {} }".data(using: String.Encoding.utf8)!
                let headers = [ "Content-Type" : "application/json;charset=utf-8"]
                return HTTPStubsResponse(data: body, statusCode: 400, headers: headers)
            } else if value == "EndSpecialCharacter" {
                let body = "{ \"Code\": 12104, \"Error\": \"Username end with special character\", \"Details\": {} }".data(using: String.Encoding.utf8)!
                let headers = [ "Content-Type" : "application/json;charset=utf-8"]
                return HTTPStubsResponse(data: body, statusCode: 400, headers: headers)
            } else if value == "UsernameToolong" {
                let body = "{ \"Code\": 12105, \"Error\": \"Username too long\", \"Details\": {} }".data(using: String.Encoding.utf8)!
                let headers = [ "Content-Type" : "application/json;charset=utf-8"]
                return HTTPStubsResponse(data: body, statusCode: 400, headers: headers)
            } else if value == "UsernameAlreadyUsed" {
                let body = "{ \"Code\": 12106, \"Error\": \"Username already used\", \"Details\": {} }".data(using: String.Encoding.utf8)!
                let headers = [ "Content-Type" : "application/json;charset=utf-8"]
                return HTTPStubsResponse(data: body, statusCode: 400, headers: headers)
            }
            
            let dbody = "{ \"Code\": 1000 }".data(using: String.Encoding.utf8)!
            return HTTPStubsResponse(data: dbody, statusCode: 400, headers: [:])
        }
        
    }

    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }

    func testAuthInfo() {
        let expectation1 = self.expectation(description: "Success completion block called")
        let authInfoOK = AuthAPI.Router.info(username: "ok")//unittest100
        let api = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID", userID: "testUserID")
        api.exec(route: authInfoOK) { (task, response: AuthInfoResponse) in
            XCTAssertEqual(response.code, 1000)
            XCTAssert(response.error == nil)
            XCTAssertTrue(response.SRPSession != nil)
            XCTAssertTrue(response.SRPSession! == "b7953c6a26d97a8f7a673afb79e6e9ce")
            expectation1.fulfill()
        }
//
//        ///
//        let expectation2 = self.expectation(description: "Success completion block called")
//        let checkNameInvalidChar = UserAPI.Router.checkUsername("InvalidCharacters")
//        let api2 = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID", userID: "testUserID")
//        api2.exec(route: checkNameInvalidChar) { (task, response) in
//            XCTAssertEqual(response.code, 12102)
//            XCTAssertEqual(response.errorMessage, "Invalid characters")
//            XCTAssert(response.error != nil)
//            expectation2.fulfill()
//        }
//
//        ///
//        let expectation3 = self.expectation(description: "Success completion block called")
//        let startSpecialCharacter = UserAPI.Router.checkUsername("StartSpecialCharacter")
//        let api3 = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID", userID: "testUserID")
//        api3.exec(route: startSpecialCharacter) { (task, response) in
//            XCTAssertEqual(response.code, 12103)
//            XCTAssertEqual(response.errorMessage, "Username start with special character")
//            XCTAssert(response.error != nil)
//            expectation3.fulfill()
//        }
//
//        ///
//        let expectationexpectation4 = self.expectation(description: "Success completion block called")
//        let endSpecialCharacter = UserAPI.Router.checkUsername("EndSpecialCharacter")
//        let api4 = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID", userID: "testUserID")
//        api4.exec(route: endSpecialCharacter) { (task, response) in
//            XCTAssertEqual(response.code, 12104)
//            XCTAssertEqual(response.errorMessage, "Username end with special character")
//            XCTAssert(response.error != nil)
//            expectationexpectation4.fulfill()
//        }
//        ///
//        let expectation5 = self.expectation(description: "Success completion block called")
//        let usernameToolong = UserAPI.Router.checkUsername("UsernameToolong")
//        let api5 = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID", userID: "testUserID")
//        api5.exec(route: usernameToolong) { (task, response) in
//            XCTAssertEqual(response.code, 12105)
//            XCTAssertEqual(response.errorMessage, "Username too long")
//            XCTAssert(response.error != nil)
//            expectation5.fulfill()
//        }///
//        let expectation6 = self.expectation(description: "Success completion block called")
//        let usernameAlreadyUsed = UserAPI.Router.checkUsername("UsernameAlreadyUsed")
//        let api6 = PMAPIService(doh: DoHMail.default, sessionUID: "testSessionUID", userID: "testUserID")
//        api6.exec(route: usernameAlreadyUsed) { (task, response) in
//            XCTAssertEqual(response.code, 12106)
//            XCTAssertEqual(response.errorMessage, "Username already used")
//            XCTAssert(response.error != nil)
//            expectation6.fulfill()
//        }
        self.waitForExpectations(timeout: 30) { (expectationError) -> Void in
            XCTAssertNil(expectationError)
        }

    }
}
