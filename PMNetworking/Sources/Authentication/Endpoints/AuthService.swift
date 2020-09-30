//
//  ErrorResponse.swift
//  PMAuthentication
//
//  Created on 20/02/2020.
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

enum AuthService {
    /*
     See BE discussion in internal ProtonTech docs: /proton/backend-communication/issues/12
    */
    
    static var trust: TrustChallenge?
    static var scheme: String = "https"
    static var host: String = "api.protonmail.ch"
    static var apiPath: String = ""
    static var apiVersion: String = "3"
    static var clientVersion: String = ""
    static var redirectUri: String = "http://protonmail.ch" // Probably, we do not actually need this thing
    
    static var baseComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = apiPath
        return urlComponents
    }
    
    static var baseHeaders: [String: String] {
        return [
            "x-pm-appversion": clientVersion,
            "x-pm-apiversion": apiVersion,
            "Accept": "application/vnd.protonmail.v1+json",
            "Content-Type": "application/json;charset=utf-8"
        ]
    }

    static func url(of path: String) -> URL {
        let urlComponents = self.baseComponents
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        return url.appendingPathComponent(path)
    }
}
