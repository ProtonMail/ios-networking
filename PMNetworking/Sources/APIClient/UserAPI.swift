//
//  UserAPI.swift
//  PMNetworking
//
//  Created by Yanfeng Zhang on 5/25/20.
//

import Foundation

public struct HumanVerificationToken {
    let type: TokenType
    let token: String
    let input: String? // Email, phone number or catcha token
    
    public init(type: TokenType, token: String, input: String? = nil) {
        self.type = type
        self.token = token
        self.input = input
    }
    
    var fullValue: String {
        switch type {
        case .email, .sms:
            return "\(input ?? ""):\(token)"
        case .payment, .captcha:
            return token
        case .invite:
            return ""
        }
    }
    
    public enum TokenType: String, CaseIterable {
        case email
        case sms
        case invite
        case payment
        case captcha
        //    case coupon // Since this isn't compatible with IAP, this option can be safely ignored
        
        static func type(fromString: String) -> TokenType? {
            for value in TokenType.allCases where value.rawValue == fromString {
                return value
            }
            return nil
        }
    }
}

public struct UserProperties {
    
    public let email: String
    public let username: String
    public let modulusID: String
    public let salt: String
    public let verifier: String
    public let appleToken: Data?
    
    public var description: String {
        return
            "Username: \(username)\n" +
            "ModulusID: \(modulusID)\n" +
            "Salt: \(salt)\n" +
            "Verifier: \(verifier)\n" +
            "HasAppleToken: \(appleToken == nil ? "No" : "Yes")\n"
    }
    
    public init(email: String, username: String, modulusID: String, salt: String, verifier: String, appleToken: Data?) {
        self.email = email
        self.username = username
        self.modulusID = modulusID
        self.salt = salt
        self.verifier = verifier
        self.appleToken = appleToken
    }
}

//Users API
//Doc: https://github.com/ProtonMail/Slim-API/blob/develop/api-spec/pm_api_users.md

class UserAPI : APIClient {
    
    static let route : String = "/users"
    
    
    ///
    static let vpnType = 2
    
    /// default user route version
    static let v_user_default : Int = 3
//    /// Check if username already taken [GET]
//    static let v_check_is_user_exist : Int = 3
//    /// Check if direct user signups are enabled [GET]
//    static let v_get_user_direct : Int = 3
//    /// Get user's info [GET]
//    static let v_get_userinfo : Int = 3
//    /// Get options for human verification [GET]
//    static let v_get_human_verify_options : Int = 3
//    /// Verify user is human [POST]
//    static let v_verify_human : Int = 3
//    /// Create user [POST]
//    static let v_create_user : Int = 3
//    /// Send a verification code [POST]
//    static let v_send_verification_code : Int = 3
    
    enum Router: Request {
        func toDictionary() -> [String : Any]? {
             return nil
        }
        
        func dict() -> [String : Any]? {
            return nil
        }
        
        case code(type: HumanVerificationToken.TokenType, receiver: String)
        case check(token: HumanVerificationToken)
        case checkUsername(String)
        case createUser(UserProperties)
        
        var path: String {
            switch self {
            case .code:
                return route + "/code"
            case .check:
                return route + "/check"
            case .checkUsername(let username):
                return route + "/available?Name=" + username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            case .createUser:
                return route
            }
        }
        
        var version: Int {
            switch self {
            case .code, .check, .checkUsername, .createUser:
                return v_user_default
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .checkUsername:
                return .get
            case  .code, .createUser:
                return .post
            case .check:
                return .put
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .checkUsername:
                return nil
            case .code(let type, let receiver):
                let destinationType: String
                switch type {
                case .email:
                    destinationType = "Address"
                case .sms:
                    destinationType = "Phone"
                case .payment, .invite, .captcha:
                    fatalError("Wrong parameter used. Payment is not supported by code endpoint.")
                }
                return [
                    "Type": type.rawValue,
                    "Destination": [
                        destinationType: receiver
                    ]
                ]
            case .check(let token):
                return [
                    "Token": "\(token.fullValue)",
                    "TokenType": token.type.rawValue,
                    "Type": vpnType
                ]
            case .createUser(let userProperties):
                var params: [String: Any] = [
                    "Email": userProperties.email,
                    "Username": userProperties.username,
                    "Type": vpnType,
                    "Auth": [
                        "Version": 4,
                        "ModulusID": userProperties.modulusID,
                        "Salt": userProperties.salt,
                        "Verifier": userProperties.verifier
                    ]
                ]
                if let token = userProperties.appleToken {
                    params["Payload"] = [
                        "higgs-boson": token.base64EncodedString()
                    ]
                }
                return params
            }
        }
    }
}
