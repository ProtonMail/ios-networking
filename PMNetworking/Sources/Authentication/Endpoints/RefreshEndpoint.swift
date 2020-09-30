//
//  RefreshEndpoint.swift
//  PMAuthentication
//
//  Created by on 21/02/2020.
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
    struct RefreshEndpoint: Endpoint {
        struct Response: Codable, CredentialConvertible {
            var code: Int
            var accessToken: String
            var expiresIn: TimeInterval
            var tokenType: String
            var scope: AuthEndpoint.Response.Scope
            var refreshToken: String
        }
        
        var request: URLRequest
        
        init(refreshToken: String,
             UID: String)
        {
            // url
            let authInfoUrl = AuthService.url(of: "/auth/refresh")
            
            // request
            var request = URLRequest(url: authInfoUrl)
            request.httpMethod = "POST"
            
            // headers
            var headers = AuthService.baseHeaders
            headers["x-pm-uid"] = UID
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            
            // body
            let body = [
            "ResponseType": "token",
            "GrantType": "refresh_token",
            "RefreshToken": refreshToken,
            "RedirectURI": AuthService.redirectUri
            ]
            request.httpBody = try? JSONEncoder().encode(body)
            
            self.request = request
        }
    }
}
