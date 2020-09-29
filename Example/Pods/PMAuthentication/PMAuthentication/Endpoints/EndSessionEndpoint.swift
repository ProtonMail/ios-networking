//
//  EndSessionEndpoint.swift
//  PMAuthentication
//
//  Created by Anatoly Rosencrantz on 05/05/2020.
//  Copyright © 2020 ProtonMail. All rights reserved.
//

import Foundation

extension AuthService {
    struct EndSessionEndpoint: Endpoint {
        struct Response: Codable {
            var code: Int
        }
        
        var request: URLRequest
        
        init(token: String, UID: String)
        {
            // url
            let authUrl = AuthService.url(of: "/auth")
            
            // request
            var request = URLRequest(url: authUrl)
            request.httpMethod = "DELETE"
            
            // headers
            var headers = AuthService.baseHeaders
            headers["Authorization"] = "Bearer " + token
            headers["x-pm-uid"] = UID
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
            
            self.request = request
        }
    }
}
