//
//  KeySaltsEndpoint.swift
//  PMAuthentication
//
//  Created by Anatoly Rosencrantz on 17/03/2020.
//  Copyright © 2020 ProtonMail. All rights reserved.
//

import Foundation

extension AuthService {
    
    /// This is a LOCKED endpoint, appropriate scope is set for the following call when you either login or call `/users/lock`, otherwise this call will fail with 403 Forbidden
    struct KeySaltsEndpoint: Endpoint {
        struct Response: Codable {
            let code: Int
            let keySalts: [AddressKeySalt]
        }
        
        var request: URLRequest
        
        init(token: String, UID: String) {
            // url
            let authInfoUrl = AuthService.url(of: "/keys/salts")
            
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
