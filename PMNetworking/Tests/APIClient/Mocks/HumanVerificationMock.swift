//
//  HumanVerificationAPITests.swift
//  ProtonMailTests - Created on 16/11/20.
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


import Foundation
import PMCommon

public class HumanCheckHelperMock: HumanVerifyDelegate {
    fileprivate let resultSuccess: Bool
    fileprivate let resultHeaders: [[String: Any]]?
    fileprivate let delay: TimeInterval
    fileprivate let resultClosure: ((@escaping(Bool) -> Void) -> Void)?
    
    public init(apiService: APIService, resultSuccess: Bool, resultHeaders: [[String: Any]]? = nil, delay: TimeInterval = 0, resultClosure: ((@escaping(Bool) -> Void) -> Void)? = nil) {
        self.resultSuccess = resultSuccess
        self.resultHeaders = resultHeaders
        self.delay = delay
        self.resultClosure = resultClosure
    }

    public func onHumanVerify(methods: [VerifyMethod], completion: (@escaping (HumanVerifyHeader, HumanVerifyIsClosed, SendVerificationCodeBlock?) -> (Void))) {
        let verificationBlock: SendVerificationCodeBlock = { (res, error)  in
           
        }
        
        func execute() {
            if (resultSuccess) {
                if let resultHeaders = resultHeaders {
                    var index = 0.0
                    resultHeaders.forEach { header in
                        index += 1
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay * index) {
                            completion(header, false, verificationBlock)
                        }
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    completion([:], true, nil)
                }
            }
        }
        
        if let resultClosure = resultClosure {
            resultClosure({ res in
                if res == true {
                    execute()
                }
            })
        } else {
            execute()
        }
    }
    
    public func getSupportURL() -> URL {
        return URL(string: "www.protonmail.com")!
    }
}
