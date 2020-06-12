//
//  Response.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/25/20.
//

import Foundation

public class Response {
    required public init() {}
    
    public var code : Int! = 1000
    public var errorMessage : String?
    var internetCode : Int? //only use when error happend.
    
    public var error : NSError?
    
    func CheckHttpStatus() -> Bool {
        return code == 200 || code == 1000
    }
    
    func CheckBodyStatus () -> Bool {
        return code == 1000
    }
    
    func ParseResponseError (_ response: [String : Any]) -> Bool {
        code = response["Code"] as? Int
        errorMessage = response["Error"] as? String
        if code == nil {
            return false
        }

        if code != 1000 && code != 1001 {
//            self.error = NSError.protonMailError(code ?? 1000,
//                                                 localizedDescription: errorMessage ?? "",
//                                                 localizedFailureReason: nil,
//                                                 localizedRecoverySuggestion: nil)
        }
        return code != 1000 && code != 1001
    }
    
    func ParseHttpError (_ error: NSError, response: [String : Any]? = nil) {//TODO::need refactor.
        self.code = 404
        if let detail = error.userInfo["com.alamofire.serialization.response.error.response"] as? HTTPURLResponse {
            self.code = detail.statusCode
        }
        else {
            internetCode = error.code
            self.code = internetCode
        }
        self.errorMessage = error.localizedDescription
        self.error = error
    }
    
    func ParseResponse (_ response: [String : Any]) -> Bool {
        return true
    }
}
