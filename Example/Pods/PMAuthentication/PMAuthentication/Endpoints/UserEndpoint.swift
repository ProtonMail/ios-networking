//
//  UserEndpoint.swift
//  PMAuthentication
//
//  Created by Anatoly Rosencrantz on 16/03/2020.
//  Copyright © 2020 ProtonMail. All rights reserved.
//

import Foundation

extension AuthService {
    struct UserInfoEndpoint: Endpoint {
        struct Response: Codable {
            let code: Int
            let user: User
        }
        
        var request: URLRequest
        
        init(token: String, UID: String) {
            // url
            let authInfoUrl = AuthService.url(of: "/users")
            
            // request
            var request = URLRequest(url: authInfoUrl)
            request.httpMethod = "GET"
            
            // headers
            var headers = AuthService.baseHeaders
            headers["Authorization"] = "Bearer " + token
            headers["x-pm-uid"] = UID
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            
            self.request = request
        }
    }
}
