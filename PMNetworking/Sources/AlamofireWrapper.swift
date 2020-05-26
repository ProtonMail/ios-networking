//
//  AlamofireWrapper.swift
//  Pods
//
//  Created by Yanfeng Zhang on 5/25/20.
//

import Foundation
//import Alamofire

//
/// implememtations wrapper
/// AFNetworkingImpl
/// AlamofireImpl
/// also mocks
//class AlamofireWarpper : NetworkLayer {
//    func initSession() {
//
//    }
//
//    func hookupSSLPining() {
//
//    }
//
//    /// response for delevey data to the third party lib
//    init() {
//        //setup session manager
//        //setup pining
//        //etc
//    }
//
//
//}



class AlamofireWarpper: NetworkLayer {
    
    //    // refresh token fai
    func initSession() {
        
    }
    
    func hookupSSLPining() {
        
    }
//    led count
//    internal var refreshTokenFailedCount = 0
//    // synchronize lock
//    internal var mutex = pthread_mutex_t()
//    // api session manager
//    fileprivate var sessionManager: AFHTTPSessionManager
//    // get session
//    func getSession() -> AFHTTPSessionManager{
//        return sessionManager;
//    }
//    ///
//    weak var delegate : APIServiceDelegate?
//    let doh : DoH = DoHMail.default
//    // MARK: - Internal methods
//    weak var sessionDeleaget : SessionDelegate?
//    /// the session ID. this can be changed
//    var sessionUID : String
//    /// network config
//    let serverConfig : APIServerConfig
//    /// the user id
//    let userID : String
    
//
//    static var sharedSessionManager: AFHTTPSessionManager? = nil
//
//    private func initSessionManager(apiHostUrl: String) -> AFHTTPSessionManager {
//        let sessionManager = AFHTTPSessionManager(baseURL: URL(string: apiHostUrl)!)
//        sessionManager.requestSerializer = AFJSONRequestSerializer()
//        sessionManager.requestSerializer.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData  //.ReloadIgnoringCacheData
//        sessionManager.requestSerializer.stringEncoding = String.Encoding.utf8.rawValue
//
//        sessionManager.responseSerializer.acceptableContentTypes?.insert("text/html")
//
//        sessionManager.securityPolicy.validatesDomainName = false
//        sessionManager.securityPolicy.allowInvalidCertificates = false
//        #if DEBUG
//        sessionManager.securityPolicy.allowInvalidCertificates = true
//        #endif
//
//        return sessionManager
//    }
       
    
//    public typealias Factory = CoreAlertServiceFactory & HumanVerificationAdapterFactory & TrustKitHelperFactory
//
//    private var alertService: CoreAlertService?
//    private var humanVerificationHandler: HumanVerificationAdapter?
//    private var trustKitHelper: TrustKitHelper?
//    private var tlsFailedRequests = [URLRequest]()
//    public func markAsFailedTLS(request: URLRequest) {
//        tlsFailedRequests.append(request)
//    }
//
//    private let requestQueue = DispatchQueue(label: "ch.protonvpn.alamofire")
//    private let sessionManager = SessionManager()
//    private var accessTokenRequestsQueue = [RequestItem]()
//    private var humanVerificationRequestsQueue = [RequestItem]()
//    private var fetchingNewAccessToken = false
//    private var fetchingNewHumanVerificationToken = false
//
//    public var refreshAccessToken: ((_ success: @escaping (() -> Void), _ failure: @escaping ((Error) -> Void)) -> Void)?
//
//    private enum ApiResponse {
//        case success(JSONDictionary)
//        case failure(Error)
//    }
//
//    public init(factory: Factory? = nil) {
//        if let factory = factory {
//            self.alertService = factory.makeCoreAlertService()
//            self.humanVerificationHandler = factory.makeHumanVerificationAdapter()
//            self.trustKitHelper = factory.makeTrustKitHelper()
//            sessionManager.adapter = self.humanVerificationHandler
//        }
//        sessionManager.retrier = GenericRequestRetrier()
//        if let trustKitHelper = trustKitHelper {
//            sessionManager.delegate.taskDidReceiveChallengeWithCompletion = trustKitHelper.authenticationChallengeTask
//        }
//    }
//
//    public func set(alertService: CoreAlertService) {
//        self.alertService = alertService
//    }
//
//    public func request(_ request: URLRequestConvertible,
//                        success: @escaping (() -> Void),
//                        failure: @escaping ((Error) -> Void)) {
//        let successWrapper: ((JSONDictionary) -> Void) = { (_) in
//            success()
//        }
//        self.request(request, success: successWrapper, failure: failure)
//    }
//
//    public func request(_ request: URLRequestConvertible,
//                        success: @escaping ((JSONDictionary) -> Void),
//                        failure: @escaping ((Error) -> Void)) {
//        do {
//            _ = try request.asURLRequest()
//            sessionManager.request(request).responseJSON(queue: requestQueue) { [weak self] response in
//                guard let `self` = self else { return }
//
//                self.debugLog(response)
//
//                switch self.filterDataResponse(response: response, forRequest: request) {
//                case .success(let json):
//                    success(json)
//                case .failure(let error):
//                    self.received(error: error, forRequest: request, success: success, failure: failure)
//                }
//            }
//        } catch let error {
//            PMLog.D("Network request failed with error: \(error)", level: .error)
//            failure(error)
//        }
//    }
//
//    public func request(_ request: URLRequestConvertible,
//                        success: @escaping ((String) -> Void),
//                        failure: @escaping ((Error) -> Void)) {
//        do {
//            _ = try request.asURLRequest()
//            sessionManager.request(request).responseString(queue: requestQueue) { response in
//                if response.result.isSuccess, let result = response.result.value {
//                    success(result)
//                }
//            }
//        } catch let error {
//            PMLog.D("Network request failed with error: \(error)", level: .error)
//            failure(error)
//        }
//    }
//
//    //new requestion function
//    func request(method: HTTPMethod,
//                 path: String, parameters: Any?,
//                 headers: [String : Any]?,
//                 authenticated: Bool = true,
//                 authRetry: Bool = true,
//                 authRetryRemains: Int = 10,
//                 customAuthCredential: AuthCredential? = nil,
//                 completion: CompletionBlock?) {
//        let authBlock: AuthTokenBlock = { token, userID, error in
//            if let error = error {
//                self.debugError(error)
//                completion?(nil, nil, error)
//            } else {
//                let parseBlock: (_ task: URLSessionDataTask?, _ response: Any?, _ error: Error?) -> Void = { task, response, error in
//                    if let error = error as NSError? {
//                        self.debugError(error)
//                        PMLog.D(api: error)
//                        var httpCode : Int = 200
//                        if let detail = error.userInfo["com.alamofire.serialization.response.error.response"] as? HTTPURLResponse {
//                            httpCode = detail.statusCode
//                        }
//                        else {
//                            httpCode = error.code
//                        }
//
//                        if authenticated && httpCode == 401 && authRetry {
//                           // AuthCredential.expireOrClear(auth?.token)
//                            if path.contains("https://api.protonmail.ch/refresh") { //tempery no need later
//                                completion?(nil, nil, error)
//                                self.delegate?.onError(error: error)
//                                UserTempCachedStatus.backup()
//                                //sharedUserDataService.signOut(true);
//                                userCachedStatus.signOut()
//                            } else {
//                                if authRetryRemains > 0 {
//                                    self.request(method: method,
//                                    path: path,
//                                    parameters: parameters,
//                                    headers: [HTTPHeader.apiVersion: 3],
//                                    authenticated: authenticated,
//                                    authRetryRemains: authRetryRemains - 1,
//                                    customAuthCredential: customAuthCredential,
//                                    completion: completion)
//                                } else {
//                                    NotificationCenter.default.post(name: .didReovke, object: nil, userInfo: ["uid": userID ?? ""])
//                                }
//                            }
//                        } else if let responseDict = response as? [String : Any], let responseCode = responseDict["Code"] as? Int {
//                            let errorMessage = responseDict["Error"] as? String ?? ""
//                            let displayError : NSError = NSError.protonMailError(responseCode,
//                                                                   localizedDescription: errorMessage,
//                                                                   localizedFailureReason: errorMessage,
//                                                                   localizedRecoverySuggestion: nil)
//                            if responseCode.forceUpgrade {
//                                // old check responseCode == 5001 || responseCode == 5002 || responseCode == 5003 || responseCode == 5004
//                                // new logic will not log user out
//                                NotificationCenter.default.post(name: .forceUpgrade, object: errorMessage)
//                                completion?(task, responseDict, displayError)
//                            } else if responseCode == APIErrorCode.API_offline {
//                                completion?(task, responseDict, displayError)
//                            } else {
//                                completion?(task, responseDict, displayError)
//                            }
//                        } else {
//                            completion?(task, nil, error)
//                        }
//                    } else {
//                        if response == nil {
//                            completion?(task, [:], nil)
//                        } else if let responseDictionary = response as? [String : Any],
//                            let responseCode = responseDictionary["Code"] as? Int {
//                            var error : NSError?
//                            if responseCode != 1000 && responseCode != 1001 {
//                                let errorMessage = responseDictionary["Error"] as? String
//                                error = NSError.protonMailError(responseCode,
//                                                                localizedDescription: errorMessage ?? "",
//                                                                localizedFailureReason: errorMessage,
//                                                                localizedRecoverySuggestion: nil)
//                            }
//
//                            if authenticated && responseCode == 401 {
//                                if authRetryRemains > 0 {
//                                    self.request(method: method,
//                                    path: path,
//                                    parameters: parameters,
//                                    headers: [HTTPHeader.apiVersion: 3],
//                                    authenticated: authenticated,
//                                    authRetryRemains: authRetryRemains - 1,
//                                    customAuthCredential: customAuthCredential,
//                                    completion: completion)
//                                } else {
//                                    NotificationCenter.default.post(name: .didReovke, object: nil, userInfo: ["uid": userID ?? ""])
//                                }
//                            } else if responseCode.forceUpgrade  {
//                                //FIXME: shouldn't be here
//                                let errorMessage = responseDictionary["Error"] as? String
//                                NotificationCenter.default.post(name: .forceUpgrade, object: errorMessage)
//                                completion?(task, responseDictionary, error)
//                            } else if responseCode == APIErrorCode.API_offline {
//                                completion?(task, responseDictionary, error)
//                            }
//                            else {
//                                completion?(task, responseDictionary, error)
//                            }
//                            self.debugError(error)
//                        } else {
//                            self.debugError(NSError.unableToParseResponse(response))
//                            completion?(task, nil, NSError.unableToParseResponse(response))
//                        }
//                    }
//                }
//                // let url = self.doh.getHostUrl() + path
//                let url = self.serverConfig.hostUrl + self.serverConfig.path + path
//                let request = self.sessionManager.requestSerializer.request(withMethod: method.toString(),
//                                                                            urlString: url,
//                                                                            parameters: parameters,
//                                                                            error: nil)
//                if let header = headers {
//                    for (k, v) in header {
//                        request.setValue("\(v)", forHTTPHeaderField: k)
//                    }
//                }
//                let accessToken = token ?? ""
//                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//                if let userid = userID {
//                    request.setValue(userid, forHTTPHeaderField: "x-pm-uid")
//                }
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
//                var task: URLSessionDataTask? = nil
//                task = self.sessionManager.dataTask(with: request as URLRequest, uploadProgress: { (progress) in
//                    //TODO::add later
//                }, downloadProgress: { (progress) in
//                    //TODO::add later
//                }, completionHandler: { (urlresponse, res, error) in
//                    self.debugError(error)
//                    if let urlres = urlresponse as? HTTPURLResponse, let allheader = urlres.allHeaderFields as? [String : Any] {
//                        //PMLog.D("\(allheader.json(prettyPrinted: true))")
//                        if let strData = allheader["Date"] as? String {
//                            // create dateFormatter with UTC time format
//                            let dateFormatter = DateFormatter()
//                            dateFormatter.calendar = .some(.init(identifier: .gregorian))
//                            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
//                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//                            if let date = dateFormatter.date(from: strData) {
//                                let timeInterval = date.timeIntervalSince1970
//                                Crypto.updateTime(Int64(timeInterval))
//                            }
//                        }
//                    }
//
//                    DoHMail.default.handleError(host: url, error: error)
//                    /// parse urlresponse
//                    parseBlock(task, res, error)
//                })
//                task!.resume()
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
//    public func upload(_ request: URLRequestConvertible,
//                       parameters: [String: String],
//                       files: [String: URL],
//                       success: @escaping ((JSONDictionary) -> Void),
//                       failure: @escaping ((Error) -> Void)) {
//
//        sessionManager.upload(multipartFormData: { multipartFormData in
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: .utf8)!, withName: key)
//            }
//            files.forEach({ (name, file) in
//                multipartFormData.append(file, withName: name)
//            })
//        },
//                              with: request,
//                              encodingCompletion: {encodingResult in
//                                switch encodingResult {
//                                case .success(let uploadRequest, _, _):
//                                    uploadRequest.responseJSON { response in
//                                        switch self.filterDataResponse(response: response, forRequest: request) {
//                                        case .success(let json):
//                                            success(json)
//                                        case .failure(let error):
//                                            self.received(error: error, forRequest: request, success: success, failure: failure)
//                                        }
//                                    }
//                                case .failure(let encodingError):
//                                    PMLog.D("File encoding error: \(encodingError)", level: .error)
//                                    failure(encodingError)
//                                }
//        })
//    }
//
//    public func getHumanVerificationToken() -> HumanVerificationToken? {
//        return self.humanVerificationHandler?.token
//    }
//
//    public func setHumanVerification(token: HumanVerificationToken?) {
//        self.humanVerificationHandler?.token = token
//    }
//
//    // MARK: - Private functions
//
//    private func filterDataResponse(response: DataResponse<Any>, forRequest request: URLRequestConvertible) -> ApiResponse {
//        if response.result.isSuccess, let statusCode = response.response?.statusCode, let json = response.result.value as? JSONDictionary, let code = json.int(key: "Code") {
//            if statusCode == 200 && code == 1000 {
//                return .success(json)
//            } else {
//                return .failure(ApiError(httpStatusCode: statusCode, code: code, localizedDescription: json.string("Error"), responseBody: json))
//            }
//        } else if let url = try? request.asURLRequest().url, let index = tlsFailedRequests.firstIndex(where: { $0.url?.absoluteString == url?.absoluteString }) {
//            tlsFailedRequests.remove(at: index)
//            return .failure(NetworkError.error(forCode: NetworkErrorCode.tls))
//        } else if response.result.isFailure, let error = response.error as NSError? {
//            return .failure(NetworkError.error(forCode: error.code))
//        } else {
//            return .failure(ApiError.unknownError)
//        }
//    }
//
//    /// Log error and try reconnecting or call failure closure
//    private func received(error: Error, forRequest request: URLRequestConvertible, success: @escaping ((JSONDictionary) -> Void), failure: @escaping ((Error) -> Void)) {
//        guard let apiError = error as? ApiError else {
//            PMLog.D("Network request failed with error: \(error)", level: .error)
//            failure(error)
//            return
//        }
//
//        if apiError.httpStatusCode == HttpStatusCode.invalidAccessToken {
//            let requestItem = RequestItem(request: request, success: success, failure: failure)
//            self.accessTokenRequestsQueue.append(requestItem)
//            if !self.fetchingNewAccessToken {
//                PMLog.D("Network request failed with error: \(error)", level: .error)
//                self.fetchNewAccessToken(failure)
//            } // else ignore error, since we are in the process of getting a new refresh token
//        } else {
//            switch apiError.code {
//            case ApiErrorCode.appVersionBad, ApiErrorCode.apiVersionBad:
//                self.alertService?.push(alert: AppUpdateRequiredAlert(apiError))
//            case ApiErrorCode.noActiveSubscription:
//                failure(apiError) // don't write these errors to the logs
//
//            case ApiErrorCode.humanVerificationRequired:
//                let requestItem = RequestItem(request: request, success: success, failure: failure)
//                self.humanVerificationRequestsQueue.append(requestItem)
//                if !self.fetchingNewHumanVerificationToken {
//                    PMLog.D("Human verification request received", level: .warn)
//                    self.fetchNewHumanVerificationToken(error: apiError, failure: failure)
//                } // else ignore error, since we are in the process of getting a human verification token
//
//            default:
//                PMLog.D("Network request failed with error: \(apiError)", level: .error)
//                failure(apiError)
//            }
//        }
//    }
//
//    // MARK: Access token
//
//    private func fetchNewAccessToken(_ failure: @escaping (Error) -> Void) {
//        fetchingNewAccessToken = true
//
//        refreshAccessToken?({ [weak self] in
//            guard let `self` = self else { return }
//            self.fetchingNewAccessToken = false
//            self.retryRequestsWithNewAccessToken()
//            }, { [weak self] (error) in
//                guard let `self` = self else { return }
//                PMLog.D("Refresh access token failed with error: \(error)")
//                self.fetchingNewAccessToken = false
//                self.failRequestsWithoutNewAccessToken(error)
//
//                guard let apiError = error as? ApiError else {
//                    failure(error)
//                    return
//                }
//
//                switch (apiError.httpStatusCode, apiError.code) {
//                case (HttpStatusCode.tooManyRequests, _):
//                    failure(error)
//                case (400...499, _):
//                    PMLog.ET("User logged out due to refresh access token failure with error: \(error)")
//                    DispatchQueue.main.async { [weak self] in
//                        guard let `self` = self else { return }
//                        self.alertService?.push(alert: RefreshTokenExpiredAlert())
//                    }
//                default:
//                    failure(error)
//                }
//        })
//    }
//
//    private func retryRequestsWithNewAccessToken() {
//        accessTokenRequestsQueue.forEach { requestItem in
//            completedRequestWithNewAccessToken(requestItem.request)
//            request(requestItem.request, success: requestItem.success, failure: requestItem.failure)
//        }
//    }
//
//    private func failRequestsWithoutNewAccessToken(_ error: Error) {
//        accessTokenRequestsQueue.removeAll()
//        // We don't call failure callbacks because user will be logged out and no more additional errors should be shown
//    }
//
//    private func completedRequestWithNewAccessToken(_ request: URLRequestConvertible) {
//        if let index = accessTokenRequestsQueue.index(where: { $0.request.urlRequest! == request.urlRequest! }) {
//            accessTokenRequestsQueue.remove(at: index)
//        }
//    }
//
//    // MARK: Human verification
//
//    private func fetchNewHumanVerificationToken(error: ApiError, failure: @escaping (Error) -> Void) {
//        guard let alertService = alertService else {
//            failure(error)
//            return
//        }
//        guard let verificationMethods = VerificationMethods.fromApiError(apiError: error) else {
//            failure(error)
//            return
//        }
//        fetchingNewHumanVerificationToken = true
//
//        let alert = UserVerificationAlert(verificationMethods: verificationMethods, message: error.localizedDescription, success: {[weak self] token in
//            guard let `self` = self else { return }
//            self.humanVerificationHandler?.token = token
//            self.fetchingNewHumanVerificationToken = false
//            self.retryRequestsAfterHumanVerification()
//
//            }, failure: {[weak self] (error) in
//                guard let `self` = self else { return }
//                PMLog.ET("Getting human verification token failed with error: \(error)")
//                self.fetchingNewHumanVerificationToken = false
//                self.failRequestsAfterHumanVerification(error)
//
//                switch (error as NSError).code {
//                case NSURLErrorTimedOut,
//                     NSURLErrorNotConnectedToInternet,
//                     NSURLErrorNetworkConnectionLost,
//                     NSURLErrorCannotConnectToHost,
//                     HttpStatusCode.serviceUnavailable,
//                     ApiErrorCode.apiOffline,
//                     ApiErrorCode.invalidEmail:
//                    failure(error)
//                default:
//                    failure(UserError.failedHumanValidation)
//                }
//        })
//        alertService.push(alert: alert)
//    }
//
//    private func retryRequestsAfterHumanVerification() {
//        humanVerificationRequestsQueue.forEach { requestItem in
//            completedRequestAfterHumanVerification(requestItem.request)
//            request(requestItem.request, success: requestItem.success, failure: requestItem.failure)
//        }
//    }
//
//    private func failRequestsAfterHumanVerification(_ error: Error) {
//        humanVerificationRequestsQueue.forEach { requestItem in
//            completedRequestAfterHumanVerification(requestItem.request)
//            requestItem.failure(error)
//        }
//    }
//
//    private func completedRequestAfterHumanVerification(_ request: URLRequestConvertible) {
//        if let index = humanVerificationRequestsQueue.index(where: { $0.request.urlRequest! == request.urlRequest! }) {
//            humanVerificationRequestsQueue.remove(at: index)
//        }
//    }
//
//    // MARK: Debugging
//
//    private func debugLog(_ response: DataResponse<Any>) {
//        #if DEBUG
//        debugPrint("======================================= start =======================================")
//        debugPrint(response.request?.url as Any)
//        debugPrint(response.request?.allHTTPHeaderFields as Any)
//        if let data = response.request?.httpBody {
//            debugPrint(String(data: data, encoding: .utf8) as Any)
//        }
//        debugPrint("------------------------------------- response -------------------------------------")
//        debugPrint(response.response?.statusCode as Any)
//        debugPrint(response.result.value as Any)
//        debugPrint("======================================= end =======================================")
//        #endif
//    }
    
}
