//
//  Route.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/22/20.
//

import Foundation

protocol Package {
    /**
     conver requset object to dictionary
     
     :returns: request dictionary
     */
    func toDictionary() -> [String: Any]?
}



//APIClient is the api client base
protocol Request : Package {
    
    // those functions shdould be overrided
//    func version() -> Int
//    func headers() -> [String : Any]
//    func isAuth() -> Bool
//    func path() -> String
//    func method() -> HTTPMethod
    //etc base functions
    
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
