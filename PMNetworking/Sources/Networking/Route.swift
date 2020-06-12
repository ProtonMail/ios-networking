//
//  Route.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/22/20.
//

import Foundation

public protocol Package {
    /**
     conver requset object to dictionary
     
     :returns: request dictionary
     */
    var parameters: [String: Any]? { get }
}

///
public enum HTTPMethod {
    case delete
    case get
    case post
    case put
    
    func toString() -> String {
        switch self {
        case .delete:
            return "DELETE"
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}

//APIClient is the api client base
public protocol Request : Package {
    // those functions shdould be overrided
    var version: Int { get }
    var path: String { get }
    var header: [String : Any]  { get }
    var method: HTTPMethod { get }
    
//    func isAuth() -> Bool
}


fileprivate let v_default : Int = 3
public extension Request {
     var version: Int {
        get {
            return v_default
        }
    }
}


//public protocol Router: URLRequestConvertible {
//    
//    var path: String { get }
//    var version: String { get }
//    var method: HTTPMethod { get }
//    var header: [String: String]? { get }
//    var parameters: [String: Any]? { get }
//    
//    var authenticatedHeader: [String: String]? { get }
//    var nonAuthenticatedHeader: [String: String]? { get }
//    
//    var parameterEncoding: ParameterEncoding { get }
//    
//    func asURLRequest() throws -> URLRequest
//}
