//
//  ProtonMailAPIService.swift
//  ProtonMail - Created on 5/22/20.
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

//REMOVE the networking ref
import AFNetworking


//This need move to a common framwork
extension NSError {
    
    convenience init(domain: String, code: Int, localizedDescription: String, localizedFailureReason: String? = nil, localizedRecoverySuggestion: String? = nil) {
        var userInfo = [NSLocalizedDescriptionKey : localizedDescription]
        
        if let localizedFailureReason = localizedFailureReason {
            userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason
        }
        
        if let localizedRecoverySuggestion = localizedRecoverySuggestion {
            userInfo[NSLocalizedRecoverySuggestionErrorKey] = localizedRecoverySuggestion
        }
        
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
    
    class func protonMailError(_ code: Int, localizedDescription: String, localizedFailureReason: String? = nil, localizedRecoverySuggestion: String? = nil) -> NSError {
        return NSError(domain: protonMailErrorDomain(), code: code, localizedDescription: localizedDescription, localizedFailureReason: localizedFailureReason, localizedRecoverySuggestion: localizedRecoverySuggestion)
    }
    
    class func protonMailErrorDomain(_ subdomain: String? = nil) -> String {
        var domain = Bundle.main.bundleIdentifier ?? "ch.protonmail"
        
        if let subdomain = subdomain {
            domain += ".\(subdomain)"
        }
        return domain
    }
    
    func getCode() -> Int {
        var defaultCode : Int = code;
        if defaultCode == Int.max {
            if let detail = self.userInfo["com.alamofire.serialization.response.error.response"] as? HTTPURLResponse {
                defaultCode = detail.statusCode
            }
        }
        return defaultCode
    }
    
    func isInternetError() -> Bool {
        var isInternetIssue = false
        if let _ = self.userInfo ["com.alamofire.serialization.response.error.response"] as? HTTPURLResponse {
        } else {
            //                        if(error?.code == -1001) {
            //                            // request timed out
            //                        }
            if self.code == -1009 || self.code == -1004 || self.code == -1001 { //internet issue
                isInternetIssue = true
            }
        }
        return isInternetIssue
    }
    
    
}


final class UserAgent {
    public static let `default` : UserAgent = UserAgent()
    
    private var cachedUS : String?
    private init () { }
    
    //eg. Darwin/16.3.0
    private func DarwinVersion() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        if let dv = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii) {
            let ndv = dv.trimmingCharacters(in: .controlCharacters)
            return "Darwin/\(ndv)"
        }
        return ""
    }
    //eg. CFNetwork/808.3
    private func CFNetworkVersion() -> String {
        let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary
        let version = dictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "CFNetwork/\(version)"
    }
    
    //eg. iOS/10_1
    private func deviceVersion() -> String {
        let currentDevice = UIDevice.current
        return "\(currentDevice.systemName)/\(currentDevice.systemVersion)"
    }
    //eg. iPhone5,2
    private func deviceName() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let data = Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN))
        if let dn = String(bytes: data, encoding: .ascii) {
            let ndn = dn.trimmingCharacters(in: .controlCharacters)
            return ndn
        }
        return "Unknown"
    }
    //eg. MyApp/1
    private func appNameAndVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as? String ?? "Unknown"
        let name = dictionary["CFBundleName"] as? String ?? "Unknown"
        return "\(name)/\(version)"
    }
    
    private func UAString() -> String {
        return "\(appNameAndVersion()) \(deviceName()) \(deviceVersion()) \(CFNetworkVersion()) \(DarwinVersion())"
    }
    
    var ua : String? {
        get {
            if cachedUS == nil {
                cachedUS = self.UAString()
            }
            return cachedUS
        }
    }
}



//Protonmail api serivce. all the network requestion must go with this.
public class PMAPIService : APIService {
    /// auth delegation
    public weak var authDelegate: AuthDelegate?
    
    ///
    public var serviceDelegate: APIServiceDelegate?
    
    /// synchronize lock
    private var mutex = pthread_mutex_t()
    
    //    /// the user id
    //    public var userID : String = ""
    
    /// the session ID. this can be changed
    public var sessionUID : String = ""
    
    /// doh with service config
    let doh : DoH
    
    /// network config
    //    let serverConfig : APIServerConfig
    
    
    /// api session manager
    private var sessionManager: AFHTTPSessionManager
    
    /// refresh token failed count
    private var refreshTokenFailedCount = 0
    
    
    //    var network : NetworkLayer
    //    var vpn : VPNInterface
    //    var doh:  DoH //depends on NetworkLayer.
    //    var queue : [Request]
    //    weak var apiServiceDelegate: APIServiceDelegate?
    //    weak var authDelegate : AuthDelegate?
    //    init(networkImpl: NetworkLayer, doh, vpn?, apiServiceDelegate?, authDelegate) {
    //        ///
    //    }
    
    // MARK: - Internal methods
    /// by default will create a non auth api service. after calling the auth function, it will set the session. then use the delation to fetch the auth data  for this session.
    public required init(doh: DoH, sessionUID: String = "") {
        // init lock
        pthread_mutex_init(&mutex, nil)
        self.doh = doh
        doh.status = .on //userCachedStatus.isDohOn ? .on : .off
        
        // set config
        //self.serverConfig = config
        self.sessionUID = sessionUID
        
        //
        // clear all response cache
        URLCache.shared.removeAllCachedResponses()
        
        // ----- this part need move the networking wrapper
        let apiHostUrl = self.doh.getHostUrl() // self.serverConfig.hostUrl
        sessionManager = AFHTTPSessionManager(baseURL: URL(string: apiHostUrl)!)
        sessionManager.requestSerializer = AFJSONRequestSerializer()
        sessionManager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData  //.ReloadIgnoringCacheData
        sessionManager.requestSerializer.stringEncoding = String.Encoding.utf8.rawValue
        
        sessionManager.responseSerializer.acceptableContentTypes?.insert("text/html")
        sessionManager.securityPolicy.allowInvalidCertificates = false
        sessionManager.securityPolicy.validatesDomainName = false
        #if DEBUG
        sessionManager.securityPolicy.allowInvalidCertificates = true
        #endif
        
        sessionManager.setSessionDidReceiveAuthenticationChallenge { session, challenge, credential -> URLSession.AuthChallengeDisposition in
            var dispositionToReturn: URLSession.AuthChallengeDisposition = .performDefaultHandling
            if let dis = self.serviceDelegate?.onChallenge(challenge: challenge, credential: credential) {
                return dis
            }
            return dispositionToReturn
        }
    }
    
    private func enableDoH() {
        
    }
    
    private func disableDoH() {
        
    }
    
    private func tryAnotherRecordDoH() {
        
    }
    
    
    public func setSessionUID(uid: String) {
        self.sessionUID = uid
    }
    
    
    
    //    internal func completionWrapperParseCompletion(_ completion: CompletionBlock?, forKey key: String) -> CompletionBlock? {
    //        if completion == nil {
    //            return nil
    //        }
    //
    //        return { task, response, error in
    //            if error != nil {
    //                completion?(task, nil, error)
    //            } else {
    //                if let parsedResponse = response?[key] as? [String : Any] {
    //                    completion?(task, parsedResponse, nil)
    //                } else {
    //                    completion?(task, nil, NSError.unableToParseResponse(response))
    //                }
    //            }
    //        }
    //    }
    //
    
    internal typealias AuthTokenBlock = (String?, String?, NSError?) -> Void
    internal func fetchAuthCredential(_ completion: @escaping AuthTokenBlock) {
        //TODO:: fix me. this is wrong. concurruncy
        DispatchQueue.global(qos: .default).async {
            pthread_mutex_lock(&self.mutex)
            let authCredential = self.authDelegate?.getToken(bySessionUID: self.sessionUID)
            guard let credential = authCredential else {
                //PMLog.D("token is empty")
                pthread_mutex_unlock(&self.mutex)
                completion(nil, nil, NSError(domain: "empty token", code: 0, userInfo: nil))
                return
            }
            
            // when local credential expired, should handle the case same as api reuqest error handling
            guard !credential.isExpired else {
                //                self.authRefresh(credential) { _, newCredential, error in
                //                    self.debugError(error)
                //                    pthread_mutex_unlock(&self.mutex)
                //                    if error != nil && error!.domain == APIServiceErrorDomain && error!.code == APIErrorCode.AuthErrorCode.invalidGrant {
                //                        DispatchQueue.main.async {
                //                            NSError.alertBadTokenToast()
                //                            self.fetchAuthCredential(completion)
                //                        }
                //                    } else if error != nil && error!.domain == APIServiceErrorDomain && error!.code == APIErrorCode.AuthErrorCode.localCacheBad {
                //                        DispatchQueue.main.async {
                //                            NSError.alertBadTokenToast()
                //                            self.fetchAuthCredential(completion)
                //                        }
                //                    } else {
                //                        if let credential = newCredential {
                //                            self.sessionDeleaget?.updateAuthCredential(credential)
                //                        }
                //                        DispatchQueue.main.async {
                //             customAuthCredential               completion(newCredential?.accessToken, self.sessionUID, error)
                //                        }
                //                    }
                //                }
                return
            }
            
            pthread_mutex_unlock(&self.mutex)
            // renew
            completion(credential.accessToken, self.sessionUID == "" ? credential.sessionID : self.sessionUID, nil)
        }
    }
    //
    //
    //    // MARK: - Request methods
    //
    //    /// downloadTask returns the download task for use with UIProgressView+AFNetworking
    //    //TODO:: update completion
    //    internal func download(byUrl url: String,
    //                           destinationDirectoryURL: URL,
    //                           headers: [String : Any]?,
    //                           authenticated: Bool = true,
    //                           customAuthCredential: AuthCredential? = nil,
    //                           downloadTask: ((URLSessionDownloadTask) -> Void)?,
    //                           completion: @escaping ((URLResponse?, URL?, NSError?) -> Void)) {
    //        let authBlock: AuthTokenBlock = { token, userID, error in
    //            if let error = error {
    //                self.debugError(error)
    //                completion(nil, nil, error)
    //            } else {
    //                let request = self.sessionManager.requestSerializer.request(withMethod: HTTPMethod.get.toString(),
    //                                                                            urlString: url,
    //                                                                            parameters: nil, error: nil)
    //                if let header = headers {
    //                    for (k, v) in header {
    //                        request.setValue("\(v)", forHTTPHeaderField: k)
    //                    }
    //                }
    //
    //                let accessToken = token ?? ""
    //                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    //                if let userID = userID {
    //                    request.setValue(userID, forHTTPHeaderField: "x-pm-uid")
    //                }
    //
    //                let appversion = "iOS_\(Bundle.main.majorVersion)"
    //                request.setValue("application/vnd.protonmail.v1+json", forHTTPHeaderField: "Accept")
    //                request.setValue(appversion, forHTTPHeaderField: "x-pm-appversion")
    //
    //                let clanguage = LanguageManager.currentLanguageEnum()
    //                request.setValue(clanguage.localeString, forHTTPHeaderField: "x-pm-locale")
    //                if let ua = UserAgent.default.ua {
    //                    request.setValue(ua, forHTTPHeaderField: "User-Agent")
    //                }
    //
    //                let sessionDownloadTask = self.sessionManager.downloadTask(with: request as URLRequest, progress: { (progress) in
    //
    //                }, destination: { (targetURL, response) -> URL in
    //                    return destinationDirectoryURL
    //                }, completionHandler: { (response, url, error) in
    //                    self.debugError(error)
    //                    completion(response, url, error as NSError?)
    //                })
    //                downloadTask?(sessionDownloadTask)
    //                sessionDownloadTask.resume()
    //            }
    //        }
    //
    //        if authenticated && customAuthCredential == nil {
    //            fetchAuthCredential(authBlock)
    //        } else {
    //            authBlock(customAuthCredential?.accessToken, customAuthCredential?.sessionID, nil)
    //        }
    //    }
    //
    //    //     internal func upload (byPath path: String,
    //    //     parameters: [String:String],
    //    //     keyPackets : Data,
    //    //     dataPacket : Data,
    //    //     signature : Data?,
    //    //     headers: [String : Any]?,
    //    //     authenticated: Bool = true,
    //    //     customAuthCredential: AuthCredential? = nil,
    //    //     completion: @escaping CompletionBlock) {
    //    //         let url = self.doh.getHostUrl() + path
    //    //         self.upload(byUrl: url,
    //    //                     parameters: parameters,
    //    //                     keyPackets: keyPackets,
    //    //                     dataPacket: dataPacket,
    //    //                     signature: signature,
    //    //                     headers: headers,
    //    //                     authenticated: authenticated,
    //    //                     customAuthCredential: customAuthCredential,
    //    //                     completion: completion)
    //    //     }
    //
    //    /**
    //     this function only for upload attachments for now.
    //
    //     :param: url        The content accept endpoint
    //     :param: parameters the request body
    //     :param: keyPackets encrypt attachment key package
    //     :param: dataPacket encrypt attachment data package
    //     */
    //    internal func upload (byPath path: String,
    //                          parameters: [String:String],
    //                          keyPackets : Data,
    //                          dataPacket : Data,
    //                          signature : Data?,
    //                          headers: [String : Any]?,
    //                          authenticated: Bool = true,
    //                          customAuthCredential: AuthCredential? = nil,
    //                          completion: @escaping CompletionBlock) {
    //
    //
    //        let url = self.serverConfig.hostUrl + path
    //
    //
    //        let authBlock: AuthTokenBlock = { token, userID, error in
    //            if let error = error {
    //                self.debugError(error)
    //                completion(nil, nil, error)
    //            } else {
    //                let request = self.sessionManager.requestSerializer.multipartFormRequest(withMethod: "POST",
    //                                                                                         urlString: url, parameters: parameters,
    //                                                                                         constructingBodyWith: { (formData) -> Void in
    //                                                                                            let data: AFMultipartFormData = formData
    //                                                                                            data.appendPart(withFileData: keyPackets, name: "KeyPackets", fileName: "KeyPackets.txt", mimeType: "" )
    //                                                                                            data.appendPart(withFileData: dataPacket, name: "DataPacket", fileName: "DataPacket.txt", mimeType: "" )
    //                                                                                            if let sign = signature {
    //                                                                                                data.appendPart(withFileData: sign, name: "Signature", fileName: "Signature.txt", mimeType: "" )
    //                                                                                            }
    //                }, error: nil)
    //
    //                if let header = headers {
    //                    for (k, v) in header {
    //                        request.setValue("\(v)", forHTTPHeaderField: k)
    //                    }
    //                }
    //
    //                let accessToken = token ?? ""
    //                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    //                if let userid = userID {
    //                    request.setValue(userid, forHTTPHeaderField: "x-pm-uid")
    //                }
    //
    //                let appversion = "iOS_\(Bundle.main.majorVersion)"
    //                request.setValue("application/vnd.protonmail.v1+json", forHTTPHeaderField: "Accept")
    //                request.setValue(appversion, forHTTPHeaderField: "x-pm-appversion")
    //
    //                let clanguage = LanguageManager.currentLanguageEnum()
    //                request.setValue(clanguage.localeString, forHTTPHeaderField: "x-pm-locale")
    //                if let ua = UserAgent.default.ua {
    //                    request.setValue(ua, forHTTPHeaderField: "User-Agent")
    //                }
    //
    //                var uploadTask: URLSessionDataTask? = nil
    //                uploadTask = self.sessionManager.uploadTask(withStreamedRequest: request as URLRequest, progress: { (progress) in
    //                    // nothing
    //                }, completionHandler: { (response, responseObject, error) in
    //                    self.debugError(error)
    //
    //                    // reachability temporarily failed because was switching from WiFi to Cellular
    //                    if (error as NSError?)?.code == -1005,
    //                        self.delegate?.isReachable() == true
    //                    {
    //                        // retry task asynchonously
    //                        DispatchQueue.global(qos: .utility).async {
    //                            self.upload(byPath: url,
    //                                        parameters: parameters,
    //                                        keyPackets: keyPackets,
    //                                        dataPacket: dataPacket,
    //                                        signature: signature,
    //                                        headers: headers,
    //                                        authenticated: authenticated,
    //                                        customAuthCredential: customAuthCredential,
    //                                        completion: completion)
    //                        }
    //                        return
    //                    }
    //
    //                    let resObject = responseObject as? [String : Any]
    //                    completion(uploadTask, resObject, error as NSError?)
    //                })
    //                uploadTask?.resume()
    //            }
    //        }
    //
    //        if authenticated && customAuthCredential == nil {
    //            fetchAuthCredential(authBlock)
    //        } else {
    //            authBlock(customAuthCredential?.accessToken, customAuthCredential?.sessionID, nil)
    //        }
    //    }
    //
    //
    
    public func request(method: HTTPMethod, path: String,
                        parameters: Any?, headers: [String : Any]?,
                        authenticated: Bool, customAuthCredential: AuthCredential?, completion: CompletionBlock?) {
        
        self.request(method: method, path: path, parameters: parameters,
                     headers: headers, authenticated: authenticated, authRetry: false, authRetryRemains: 10,
                     customAuthCredential: nil, completion: completion)
        
    }
    //new requestion function
    func request(method: HTTPMethod,
                 path: String,
                 parameters: Any?,
                 headers: [String : Any]?,
                 authenticated: Bool = true,
                 authRetry: Bool = true,
                 authRetryRemains: Int = 10,
                 customAuthCredential: AuthCredential? = nil,
                 completion: CompletionBlock?) {
        let authBlock: AuthTokenBlock = { token, userID, error in
            if let error = error {
                self.debugError(error)
                completion?(nil, nil, error)
            } else {
                let parseBlock: (_ task: URLSessionDataTask?, _ response: Any?, _ error: Error?) -> Void = { task, response, error in
                    if let error = error as NSError? {
                        self.debugError(error)
                        //PMLog.D(api: error)
                        var httpCode : Int = 200
                        if let detail = error.userInfo["com.alamofire.serialization.response.error.response"] as? HTTPURLResponse {
                            httpCode = detail.statusCode
                        }
                        else {
                            httpCode = error.code
                        }
                        
                        if authenticated && httpCode == 401 && authRetry {
                            // AuthCredential.expireOrClear(auth?.token)
                            if path.contains("https://api.protonmail.ch/refresh") { //tempery no need later
                                completion?(nil, nil, error)
                                self.authDelegate?.onLogout()
                                //self.delegate?.onError(error: error)
                                //UserTempCachedStatus.backup()
                                ////sharedUserDataService.signOut(true);
                                //userCachedStatus.signOut()
                            } else {
                                if authRetryRemains > 0 {
                                    self.request(method: method,
                                                 path: path,
                                                 parameters: parameters,
                                                 headers: [HTTPHeader.apiVersion: 3],
                                                 authenticated: authenticated,
                                                 authRetryRemains: authRetryRemains - 1,
                                                 customAuthCredential: customAuthCredential,
                                                 completion: completion)
                                } else {
                                    self.authDelegate?.onRevoke()
                                    //NotificationCenter.default.post(name: .didReovke, object: nil, userInfo: ["uid": userID ?? ""])
                                }
                            }
                        } else if let responseDict = response as? [String : Any], let responseCode = responseDict["Code"] as? Int {
                            let errorMessage = responseDict["Error"] as? String ?? ""
                            let displayError : NSError = NSError.protonMailError(responseCode,
                                                                                 localizedDescription: errorMessage,
                                                                                 localizedFailureReason: errorMessage,
                                                                                 localizedRecoverySuggestion: nil)
                            //                            if responseCode.forceUpgrade {
                            //                                // old check responseCode == 5001 || responseCode == 5002 || responseCode == 5003 || responseCode == 5004
                            //                                // new logic will not log user out
                            //                               // NotificationCenter.default.post(name: .forceUpgrade, object: errorMessage)
                            //                                completion?(task, responseDict, displayError)
                            //                            }
                            //                            else if responseCode == APIErrorCode.API_offline {
                            //                                completion?(task, responseDict, displayError)
                            //                            }
                            //                            else {
                            completion?(task, responseDict, displayError)
                            //                            }
                        } else {
                            completion?(task, nil, error)
                        }
                    } else {
                        if response == nil {
                            completion?(task, [:], nil)
                        } else if let responseDictionary = response as? [String : Any],
                            let responseCode = responseDictionary["Code"] as? Int {
                            var error : NSError?
                            if responseCode != 1000 && responseCode != 1001 {
                                let errorMessage = responseDictionary["Error"] as? String
                                error = NSError.protonMailError(responseCode,
                                                                localizedDescription: errorMessage ?? "",
                                                                localizedFailureReason: errorMessage,
                                                                localizedRecoverySuggestion: nil)
                            }
                            
                            if authenticated && responseCode == 401 {
                                if authRetryRemains > 0 {
                                    self.request(method: method,
                                                 path: path,
                                                 parameters: parameters,
                                                 headers: [HTTPHeader.apiVersion: 3],
                                                 authenticated: authenticated,
                                                 authRetryRemains: authRetryRemains - 1,
                                                 customAuthCredential: customAuthCredential,
                                                 completion: completion)
                                } else {
                                    self.authDelegate?.onRevoke()
                                    //NotificationCenter.default.post(name: .didReovke, object: nil, userInfo: ["uid": userID ?? ""])
                                }
                            }
                                //                            else if responseCode.forceUpgrade  {
                                //                                //FIXME: shouldn't be here
                                //                                let errorMessage = responseDictionary["Error"] as? String
                                //                                NotificationCenter.default.post(name: .forceUpgrade, object: errorMessage)
                                //                                completion?(task, responseDictionary, error)
                                //                            } else if responseCode == APIErrorCode.API_offline {
                                //                                completion?(task, responseDictionary, error)
                                //                            }
                            else {
                                completion?(task, responseDictionary, error)
                            }
                            self.debugError(error)
                        } else {
                            //                            self.debugError(NSError.unableToParseResponse(response))
                            //                            completion?(task, nil, NSError.unableToParseResponse(response))
                        }
                    }
                }
                // let url = self.doh.getHostUrl() + path
                let url = self.doh.getHostUrl() + path
                
                do {
                    let request = try self.sessionManager.requestSerializer.request(withMethod: method.toString(),
                                                                                    urlString: url,
                                                                                    parameters: parameters)
                    if let header = headers {
                        for (k, v) in header {
                            request.setValue("\(v)", forHTTPHeaderField: k)
                        }
                    }
                    let accessToken = token ?? ""
                    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                    if let userid = userID {
                        request.setValue(userid, forHTTPHeaderField: "x-pm-uid")
                    }
                    
                    // move to delegte
                    let appversion = "iOS_\(Bundle.main.majorVersion)"
                    request.setValue("application/vnd.protonmail.v1+json", forHTTPHeaderField: "Accept")
                    request.setValue(appversion, forHTTPHeaderField: "x-pm-appversion")
                    
                    // todo
                    //let clanguage = LanguageManager.currentLanguageEnum()
                    //request.setValue(clanguage.localeString, forHTTPHeaderField: "x-pm-locale")
                    
                    if let ua = UserAgent.default.ua {
                        request.setValue(ua, forHTTPHeaderField: "User-Agent")
                    }
                    
                    var task: URLSessionDataTask? = nil
                    task = self.sessionManager.dataTask(with: request as URLRequest, uploadProgress: { (progress) in
                        //TODO::add later
                        
                    }, downloadProgress: { (progress) in
                        //TODO::add later
                        print("in progress")
                    }, completionHandler: { (urlresponse, res, error) in
                        self.debugError(error)
                        if let urlres = urlresponse as? HTTPURLResponse,
                            let allheader = urlres.allHeaderFields as? [String : Any] {
                            //PMLog.D("\(allheader.json(prettyPrinted: true))")
                            if let strData = allheader["Date"] as? String {
                                // create dateFormatter with UTC time format
                                let dateFormatter = DateFormatter()
                                dateFormatter.calendar = .some(.init(identifier: .gregorian))
                                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                if let date = dateFormatter.date(from: strData) {
                                    let timeInterval = date.timeIntervalSince1970
                                    self.serviceDelegate?.onUpdate(serverTime: Int64(timeInterval))
                                }
                            }
                        }
                        
                        self.doh.handleError(host: url, error: error)
                        /// parse urlresponse
                        parseBlock(task, res, error)
                    })
                    task!.resume()
                    
                } catch let error {
                    completion?(nil, nil, error as NSError)
                }
            }
        }
        
        if authenticated && customAuthCredential == nil {
            fetchAuthCredential(authBlock)
        } else {
            authBlock(customAuthCredential?.accessToken, customAuthCredential?.sessionID, nil)
        }
    }
    
    func debugError(_ error: NSError?) {
        #if DEBUG
        // nothing
        #endif
    }
    func debugError(_ error: Error?) {
        #if DEBUG
        // nothing
        #endif
    }
}

