//
//  MessageAPI.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/22/20.
//

import Foundation

class MessageAPI : APIClient {
    
    static let route :String = "/messages"
    
    //Get a list of message metadata [GET]
    static let v_fetch_messages : Int = 3
    
    //Get grouped message count [GET]
    static let v_message_count : Int = 3
    
    static let v_create_draft : Int = 3
    
    static let v_update_draft : Int = 3
    
    // inlcude read/unread
    static let V_MessageActionRequest : Int = 3
    
    //Send a message [POST]
    static let v_send_message : Int = 3
    
    //Label/move an array of messages [PUT]
    static let v_label_move_msgs : Int = 3
    
    //Unlabel an array of messages [PUT]
    static let v_unlabel_msgs : Int = 3
    
    //Delete all messages with a label/folder [DELETE]
    static let v_empty_label_folder : Int = 3
    
    //Delete an array of messages [PUT]
    static let v_delete_msgs : Int = 3
    
    //Undelete Messages [/messages/undelete]
    static let v_undelete_msgs : Int = 3
    
    //Label/Move Messages [/messages/label] [PUT]
    static let v_apply_label_to_messages : Int = 3
    
    //Unlabel Messages [/messages/unlabel] [PUT]
    static let v_remove_label_from_message : Int = 3

//    enum Router: Request {
//        var version: Int
//        
//        var path: String
//        
//        var apiVersion: String
//        
//        var header: [String : Any]
//        
//        var parameters: [String : Any]?
//        
//        var method: HTTPMethod
//        
//        func toDictionary() -> [String : Any]? {
//            return nil
//        }
//        
////        case checkUsername(String)
////        var path: String {
////            switch self {
////            case .checkUsername(let username):
////                return route + "/users/available/{username}"
////            }
////        }
////        func dict() -> [String : Any]? {
////            return nil
////        }
//    }
}




//
//
//
//enum UserRouter: Router {
//
//    case code(type: HumanVerificationToken.TokenType, receiver: String)
//    case check(token: HumanVerificationToken)
//    case checkUsername(String)
//    case createUser(UserProperties)
//
//    var path: String {
//        let base = ApiConstants.baseURL
//        switch self {
//        case .code:
//            return base + "/users/code"
//        case .check:
//            return base + "/users/check"
//        case .checkUsername(let username):
//            return base + "/users/available?Name=" + username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//        case .createUser:
//            return base + "/users"
//        }
//    }
//
//    var version: String {
//        switch self {
//        case .code, .check, .checkUsername, .createUser:
//            return "3"
//        }
//    }
//
//    var method: HTTPMethod {
//        switch self {
//        case .checkUsername:
//            return .get
//        case  .code, .createUser:
//            return .post
//        case .check:
//            return .put
//        }
//    }
//
//    var parameters: [String: Any]? {
//        switch self {
//        case .checkUsername:
//            return nil
//        case .code(let type, let receiver):
//            let destinationType: String
//            switch type {
//            case .email:
//                destinationType = "Address"
//            case .sms:
//                destinationType = "Phone"
//            case .payment, .invite, .captcha:
//                fatalError("Wrong parameter used. Payment is not supported by code endpoint.")
//            }
//            return [
//                "Type": type.rawValue,
//                "Destination": [
//                    destinationType: receiver
//                ]
//            ]
//        case .check(let token):
//            return [
//                "Token": "\(token.fullValue)",
//                "TokenType": token.type.rawValue,
//                "Type": vpnType
//            ]
//        case .createUser(let userProperties):
//            var params: [String: Any] = [
//                "Email": userProperties.email,
//                "Username": userProperties.username,
//                "Type": vpnType,
//                "Auth": [
//                    "Version": 4,
//                    "ModulusID": userProperties.modulusID,
//                    "Salt": userProperties.salt,
//                    "Verifier": userProperties.verifier
//                ]
//            ]
//            if let token = userProperties.appleToken {
//                params["Payload"] = [
//                    "higgs-boson": token.base64EncodedString()
//                ]
//            }
//            return params
//        }
//    }
//}
