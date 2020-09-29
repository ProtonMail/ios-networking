//
//  Address.swift
//  PMAuthentication
//
//  Created by Anatoly Rosencrantz on 17/03/2020.
//  Copyright © 2020 ProtonMail. All rights reserved.
//

import Foundation

public struct Address: Codable {
    public typealias AddressID = String
    public let ID: AddressID
    public let domainID: String
    public let email: String
    public let send: Int
    public let receive: Int
    public let status: Int
    public let type: Int
    public let order: Int
    public let displayName: String
    public let signature: String
    public let hasKeys: Int
    public let keys: [AddressKey]
}

public struct AddressKey: Codable {
    public typealias AddressKeyID = String
    public let ID: AddressKeyID
    public let version: Int
    public let flags: Int
    public let privateKey: String
    public let token: String?
    public let signature: String?
    public let primary: Int
    
//    public let Activation: null
}

public struct AddressKeySalt: Codable {
    public typealias AddressKeySaltID = String
    public let ID: AddressKeySaltID
    public let keySalt: String?
}
