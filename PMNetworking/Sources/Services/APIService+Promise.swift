//
//  APIService.swift
//  Pods
//
//  Created on 5/22/20.
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

// swiftlint:disable todo

import Foundation

#if canImport(PromiseKit)

import PromiseKit
import AwaitKit

public extension APIService {
//    // init
//    func exec<T>(route: Request) -> T? where T: Response {
//        var ret_res: T?
//        var ret_error: NSError?
//        let sema = DispatchSemaphore(value: 0)
//        // TODO :: 1 make a request , 2 wait for the respons async 3. valid response 4. parse data into response 5. some data need save into database.
//        let completionWrapper: CompletionBlock = { _, res, error in
//            defer {
//                sema.signal()
//            }
//            let realType = T.self
//            let apiRes = realType.init()
//            if error != nil {
//                // TODO check error
//                apiRes.ParseHttpError(error!)
//                ret_error = apiRes.error
//                return
//            }
//
//            if res == nil {
//                // TODO:: check res
//                // apiRes.error = NSError.badResponse()
//                ret_error = apiRes.error
//                return
//            }
//
//            var hasError = apiRes.ParseResponseError(res!)
//            if !hasError {
//                hasError = !apiRes.ParseResponse(res!)
//            }
//            if hasError {
//                ret_error = apiRes.error
//                return
//            }
//            ret_res = apiRes
//        }
//        // TODO:: missing auth
//        var header = route.header
//        header[HTTPHeader.apiVersion] = route.version
//        self.request(method: route.method, path: route.path,
//                     parameters: route.parameters,
//                     headers: header,
//                     authenticated: route.isAuth,
//                     autoRetry: route.autoRetry,
//                     customAuthCredential: route.authCredential,
//                     completion: completionWrapper)
//
//        // wait operations
//        _ = sema.wait(timeout: DispatchTime.distantFuture)
//        if let e = ret_error {
//            // TODO::fix me
//            print(e.localizedDescription)
//        }
//        return ret_res
//    }
//
//    func exec<T>(route: Request,
//                 complete: @escaping  (_ task: URLSessionDataTask?, _ response: T) -> Void) where T: Response {
//
//        // 1 make a request , 2 wait for the respons async 3. valid response 4. parse data into response 5. some data need save into database.
//        let completionWrapper: CompletionBlock = { task, res, error in
//            let realType = T.self
//            let apiRes = realType.init()
//            if error != nil {
//                apiRes.ParseHttpError(error!, response: res)
//                if let resRaw = res {
//                    _ = apiRes.ParseResponse(resRaw)
//                }
//                complete(task, apiRes)
//                return
//            }
//
//            if res == nil {
//                // TODO:: check res
//                // apiRes.error = NSError.badResponse()
//                complete(task, apiRes)
//                return
//            }
//
//            var hasError = apiRes.ParseResponseError(res!)
//            if !hasError {
//                hasError = !apiRes.ParseResponse(res!)
//            }
//            complete(task, apiRes)
//        }
//
//        var header = route.header
//        header[HTTPHeader.apiVersion] = route.version
//        self.request(method: route.method, path: route.path,
//                     parameters: route.parameters,
//                     headers: header,
//                     authenticated: route.isAuth,
//                     autoRetry: route.autoRetry,
//                     customAuthCredential: route.authCredential,
//                     completion: completionWrapper)
//    }
//
//    func exec<T>(route: Request, complete: @escaping (_ response: T) -> Void) where T: Response {
//
//        // 1 make a request , 2 wait for the respons async 3. valid response 4. parse data into response 5. some data need save into database.
//        let completionWrapper: CompletionBlock = { _, res, error in
//            let realType = T.self
//            let apiRes = realType.init()
//            if error != nil {
//                // TODO check error
//                apiRes.ParseHttpError(error!, response: res)
//                if let resRaw = res {
//                    _ = apiRes.ParseResponse(resRaw)
//                }
//                complete(apiRes)
//                return
//            }
//
//            if res == nil {
//                // TODO:: check res
//                // apiRes.error = NSError.badResponse()
//                complete(apiRes)
//                return
//            }
//
//            var hasError = apiRes.ParseResponseError(res!)
//            if !hasError {
//                hasError = !apiRes.ParseResponse(res!)
//            }
//            complete(apiRes)
//        }
//
//        var header = route.header
//        header[HTTPHeader.apiVersion] = route.version
//        self.request(method: route.method, path: route.path,
//                     parameters: route.parameters,
//                     headers: header,
//                     authenticated: route.isAuth,
//                     autoRetry: route.autoRetry,
//                     customAuthCredential: route.authCredential,
//                     completion: completionWrapper)
//    }
//
//    func exec<T>(route: Request, complete: @escaping (_ task: URLSessionDataTask?, _ result: Result<T, Error>) -> Void) where T: Codable {
//
//        // 1 make a request , 2 wait for the respons async 3. valid response 4. parse data into response 5. some data need save into database.
//        let completionWrapper: CompletionBlock = { task, res, error in
//            do {
//                if let res = res {
//                    // this is a workaround for afnetworking, will change it
//                    let responseData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
//
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .decapitaliseFirstLetter
//                    // server error code
//                    if let error = try? decoder.decode(ErrorResponse.self, from: responseData) {
//                        throw NSError(error)
//                    }
//                    // server SRP
//                    let decodedResponse = try decoder.decode(T.self, from: responseData)
//                    complete(task, .success(decodedResponse))
//                } else {
//                    // todo fix the cast
//                    complete(task, .failure(error!))
//                }
//
//            } catch let err {
//                complete(task, .failure(err))
//            }
//        }
//        var header = route.header
//        header[HTTPHeader.apiVersion] = route.version
//        self.request(method: route.method, path: route.path,
//                     parameters: route.parameters,
//                     headers: header,
//                     authenticated: route.isAuth,
//                     autoRetry: route.autoRetry,
//                     customAuthCredential: route.authCredential,
//                     completion: completionWrapper)
//    }
//
//    func exec<T>(route: Request, complete: @escaping (_ result: Result<T, Error>) -> Void) where T: Codable {
//        // 1 make a request , 2 wait for the respons async 3. valid response 4. parse data into response 5. some data need save into database.
//        let completionWrapper: CompletionBlock = { _, res, error in
//            do {
//                if let res = res {
//                    // this is a workaround for afnetworking, will change it
//                    let responseData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
//
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .decapitaliseFirstLetter
//                    // server error code
//                    if let error = try? decoder.decode(ErrorResponse.self, from: responseData) {
//                        throw NSError(error)
//                    }
//                    // server SRP
//                    let decodedResponse = try decoder.decode(T.self, from: responseData)
//                    complete(.success(decodedResponse))
//                } else {
//                    // todo fix the cast
//                    complete(.failure(error!))
//                }
//
//            } catch let err {
//                complete(.failure(err))
//            }
//        }
//        var header = route.header
//        header[HTTPHeader.apiVersion] = route.version
//        self.request(method: route.method, path: route.path,
//                     parameters: route.parameters,
//                     headers: header,
//                     authenticated: route.isAuth,
//                     autoRetry: route.autoRetry,
//                     customAuthCredential: route.authCredential,
//                     completion: completionWrapper)
//    }

    func run<T>(route: Request) -> Promise<T> where T: Response {
        // 1 make a request , 2 wait for the respons async 3. valid response 4. parse data into response 5. some data need save into database.
        let deferred = Promise<T>.pending()
        let completionWrapper: CompletionBlock = { _, res, error in
            let realType = T.self
            let apiRes = realType.init()

            if error != nil {
                apiRes.ParseHttpError(error!)
                deferred.resolver.reject(error!)
                return
            }

            if res == nil {
                // TODO check res
                deferred.resolver.reject(NSError.badResponse())
                return
            }

            var hasError = apiRes.ParseResponseError(res!)
            if !hasError {
                hasError = !apiRes.ParseResponse(res!)
            }
            if hasError {
                deferred.resolver.reject(apiRes.error!)
            } else {
                deferred.resolver.fulfill(apiRes)
            }
        }

        var header = route.header
        header[HTTPHeader.apiVersion] = route.version
        self.request(method: route.method,
                     path: route.path,
                     parameters: route.parameters,
                     headers: header,
                     authenticated: route.isAuth,
                     autoRetry: route.autoRetry,
                     customAuthCredential: route.authCredential,
                     completion: completionWrapper)

        return deferred.promise
    }
}

#endif
