//
//  UserAPI.swift
//  PMNetworking
//
//  Created by on 5/25/20.
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

//Test API
//Humanverify test: https://gitlab.protontech.ch/ProtonMail/Slim-API/blob/develop/api-spec/pm_api_test.md

public enum VerifyMethod: String {
    case captcha
    case sms
    case email
    case invite
    case payment
    case coupon

    public init?(rawValue: String) {
        switch rawValue {
        case "sms": self = .sms
        case "email": self = .email
        case "captcha": self = .captcha
        default:
            return nil
        }
    }
    var localizedTitle: String {
        switch self {
        case .sms:
            return "SMS"
        case .email:
            return "Email"
        case .captcha:
            return "CAPTCHA"
        default:
            return ""
        }
    }

    var toString: String {
        switch self {
        case .sms:
            return "sms"
        case .email:
            return "email"
        case .captcha:
            return "captcha"
        default:
            return ""
        }
    }
}

public class TestApiClient: Client {
    public var apiService: APIService
    public init(api: APIService) {
        self.apiService = api
    }
    static let route: String = "/internal/tests"
    public enum Router: Request {
        case humanverify(destination: String?, type: VerifyMethod?, token: String?)
        public var path: String {
            switch self {
            case .humanverify:
                return route + "/humanverification"
            }
        }
        public var isAuth: Bool {
            return true
        }
        public var header: [String: Any] {
            switch self {
            case .humanverify(let destination, let type, let token):
                if let dest = destination, let typ = type, let str = token {
                    let dict = ["x-pm-human-verification-token-type": typ.toString,
                                "x-pm-human-verification-token": dest == "" ? str : "\(dest):\(str)"]
                    return dict
                }
            }
            return [:]
        }
        public var apiVersion: Int {
            return 3
        }
        public var method: HTTPMethod {
            switch self {
            case .humanverify:
                return .post
            }
        }
        public var parameters: [String: Any]? {
            return [:]
        }
    }
}

extension TestApiClient {
    // 3 ways.
    //  1. primise kit
    //  2. delaget
    //  3. combin
    public func triggerHumanVerify(destination: String?, type: VerifyMethod?, token: String?,
                                   complete: @escaping  (_ task: URLSessionDataTask?, _ response: HumanVerificationResponse) -> Void) {
        let route = Router.humanverify(destination: destination, type: type, token: token)
        self.apiService.exec(route: route, complete: complete)
    }

    public func triggerHumanVerifyRoute(destination: String?, type: VerifyMethod?, token: String?) -> Router {
        return Router.humanverify(destination: destination, type: type, token: token)
    }
}

class TestApi: Request {
    var path: String = "/tests/humanverification"
    var header: [String: Any] = [:]
    var method: HTTPMethod = .get
    var parameters: [String: Any]?
}

public class HumanVerificationResponse: Response {
    public var supported: [VerifyMethod] = []

    public override func ParseResponse(_ response: [String: Any]) -> Bool {
        if let details  = response["Details"] as? [String: Any] {
            if let support = details["HumanVerificationMethods"] as? [String] {
                for item in support {
                    if let method = VerifyMethod(rawValue: item) {
                        supported.append(method)
                    }
                }
            }
        }
        return true
    }
}

public struct ExpireTokenResponse: Codable {
    public var code: Int
}

public class ExpireToken: Request {
    let uid: String
    public init(uid: String) {
        self.uid = uid
    }
    public var path: String {
        return "/internal/quark/user:expire:access:token?UID=\(self.uid)"
    }
    public var method: HTTPMethod = .get
    public var parameters: [String: Any]?

    public var isAuth: Bool {
        return false
    }
}
