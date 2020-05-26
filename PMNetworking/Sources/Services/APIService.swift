//
//  APIService.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/22/20.
//

import Foundation

/// http headers key
struct HTTPHeader {
    static let apiVersion = "x-pm-apiversion"
}

///
enum HTTPMethod {
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

///
protocol APIServerConfig  {
    //host name    xxx.xxxxxxx.com
    var host : String { get }
    // http https ws wss etc ...
    var `protocol` : String {get}
    // prefixed path after host example:  /api
    var path : String {get}
    // full host with protocol, without path
    var hostUrl : String {get}
}

extension APIServerConfig {
    var hostUrl : String {
        get {
            return self.protocol + "://" + self.host
        }
    }
}

//Predefined servers, could also add the serverlist load from config env later
enum Server : APIServerConfig {
    case live //"api.protonmail.ch"
    case testlive //"test-api.protonmail.ch"
    
    case dev1 //"dev.protonmail.com"
    case dev2 //"dev-api.protonmail.ch"
    
    case blue //"protonmail.blue"
    case midnight //"midnight.protonmail.blue"
    
    //local test
    //static let URL_HOST : String = "http://127.0.0.1"  //http
    
    var host: String {
        get {
            switch self {
            case .live:
                return "api.protonmail.ch"
            case .blue:
                return "protonmail.blue"
            case .midnight:
                return "midnight.protonmail.blue"
            case .testlive:
                return "test-api.protonmail.ch"
            case .dev1:
                return "dev.protonmail.com"
            case .dev2:
                return "dev-api.protonmail.ch"
            }
        }
    }
    
    var path: String {
        get {
            switch self {
            case .live, .testlive, .dev2:
                return ""
            case .blue, .midnight, .dev1:
                return "/api"
            }
        }
    }
    
    var `protocol`: String {
        get {
            return "https"
        }
    }

}

//enum <T> {
//    case failure(Error)
//    case success(T)
//}

typealias CompletionBlock = (_ task: URLSessionDataTask?, _ response: [String : Any]?, _ error: NSError?) -> Void
protocol API {
    func request(method: HTTPMethod, path: String,
                 parameters: Any?, headers: [String : Any]?,
                 authenticated: Bool,
                 customAuthCredential: AuthCredential?,
                 completion: CompletionBlock?)
}

/// this is auth UI related
protocol APIServiceDelegate: class {
    func onUpdate(serverTime: Int64)
    //func onError(error: NSError)
    //func isReachable() -> Bool
    //func dohTroubleshot()
    //func relogin()
    //func humanverify()
    
}

/// this is auth related delegate in background
protocol AuthDelegate: class {
    func getToken(bySessionUID uid: String) -> AuthCredential?
    //func updateAuthCredential(_ credential: PMAuthentication.Credential)
    func onUpdate(auth: AuthCredential)
    func onLogout()
    func onRevoke()
    func onRefresh()
}

protocol APIService {
    //var network : NetworkLayer {get}
    //var vpn : VPNInterface {get}
    //var doh:  DoH  {get}//depends on NetworkLayer. {get}
    //var queue : [Request] {get}
    var serviceDelegate: APIServiceDelegate? {get}
    var authDelegate : AuthDelegate? {get}
}

class TestResponse : Response {
    
}

typealias RequestComplete = (_ task: URLSessionDataTask?, _ response: Response) -> Void
extension APIService {
    //init
    func exec<T>(route: Request) -> T? where T : Response {
        var ret_res : T? = nil
        var ret_error : NSError? = nil
        let sema = DispatchSemaphore(value: 0);
        //TODO :: 1 make a request , 2 wait for the respons async 3. valid response 4. parse data into response 5. some data need save into database.
        let completionWrapper: CompletionBlock = { task, res, error in
            defer {
                sema.signal();
            }
            let realType = T.self
            let apiRes = realType.init()
            if error != nil {
                //TODO check error
                apiRes.ParseHttpError(error!)
                ret_error = apiRes.error
                return
            }
            
            if res == nil {
                // TODO check res
                //apiRes.error = NSError.badResponse()
                ret_error = apiRes.error
                return
            }
            
            var hasError = apiRes.ParseResponseError(res!)
            if !hasError {
                hasError = !apiRes.ParseResponse(res!)
            }
            if hasError {
                ret_error = apiRes.error
                return
            }
            ret_res = apiRes
        }
        //TODO:: missing auth
        //        api.request(method: self.method(), path: self.path(),
        //                    parameters: self.toDictionary(), headers: [HTTPHeader.apiVersion: self.apiVersion()],
        //                    authenticated: self.getIsAuthFunction(), customAuthCredential: self.authCredential, completion: completionWrapper)
        
        //wait operations
        let _ = sema.wait(timeout: DispatchTime.distantFuture)
        //        if let e = ret_error {
        //            throw e
        //        }
        return ret_res
    }
    
    func exec<T>(route: Request,
                 complete: (_ task: URLSessionDataTask?, _ response: T) -> Void) {
        
    }
    
    
//    func exec(content: URLRequestConvertible ) {
//           // get doh url
//
//           // check if enable vpn
//
//           //build body
//
//           //build the request
//
//           //queue requests
//
//           // pass request to networklayer
//
//           // waiting response
//
//           //complete/error
//       }
//
//       func completeHanlding() {
//           //
//       }
//       func errorHandling() {
//           // if doh do
//               //retry
//           // if humanverification do
//           // if networking issue do
//           // if token expiared do
//               // renew token with authitection framewrok
//           // if renew token failed do
//
//           // a lot of error handling here and will trigger delegates
//       }
}
