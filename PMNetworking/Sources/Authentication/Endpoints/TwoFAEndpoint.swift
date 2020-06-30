//
//  AuthInfoResponse.swift
//  PMAuthentication
//
//  Created by on 20/02/2020.
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

extension AuthService {
    struct TwoFAEndpoint: Endpoint {
        struct Response: Codable {
            var code: Int
            var scope: CredentialConvertible.Scope
        }
        
        var request: URLRequest
        
        init(code: Int,
             token: String,
             UID: String)
        {
            // url
            let authInfoUrl = AuthService.url(of: "/auth/2fa")
            
            // request
            var request = URLRequest(url: authInfoUrl)
            request.httpMethod = "POST"
            
            // headers
            var headers = AuthService.baseHeaders
            headers["Authorization"] = "Bearer " + token
            headers["x-pm-uid"] = UID
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            
            // body
            let body = [
            "TwoFactorCode": code
            ]
            request.httpBody = try? JSONEncoder().encode(body)
            
            self.request = request
        }
    }
}
