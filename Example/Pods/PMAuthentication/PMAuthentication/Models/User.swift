//
//  User.swift
//  PMAuthentication
//
//  Created by Anatoly Rosencrantz on 17/03/2020.
//  Copyright © 2020 ProtonMail. All rights reserved.
//

import Foundation

public struct User: Codable {
    public let ID: String
    public let name: String
    public let usedSpace: Double
    public let currency: String
    public let credit: Int
    public let maxSpace: Double
    public let maxUpload: Double
    public let subscribed: Int
    public let services: Int
    public let role: Int
    public let `private`: Int
    public let delinquent: Int
    public let email: String
    public let displayName: String
    public let keys: [UserKey]
}

public struct UserKey: Codable {
    public let ID: String
    public let version: Int
    public let primary: Int
    public let privateKey: String
    public let fingerprint: String
}
