//
//  SetupKeysEndpoint.swift
//  PMAuthentication
//
//  Created by Igor Kulman on 21.12.2020.
//  Copyright © 2020 ProtonMail. All rights reserved.
//

import Foundation
import PMCommon

extension AuthService {
    struct SetupKeysEndpointResponse: Codable {
        let code: Int
    }

    struct SetupKeysEndpoint: Request {
        let addressID: String
        let privateKey: String
        let signedKeyList: [String: Any]
        let keySalt: String //base64 encoded need random value
        let passwordAuth: PasswordAuth

        var path: String {
            return "/keys/setup"
        }
        var method: HTTPMethod {
            return .post            
        }

        var isAuth: Bool {
            return true
        }

        var auth: AuthCredential?
        var authCredential: AuthCredential? {
            return self.auth
        }

        var parameters: [String: Any]? {
            let address: [String: Any] = [
                "AddressID": self.addressID,
                "PrivateKey": self.privateKey,
                "SignedKeyList": self.signedKeyList
            ]

            let out: [String: Any] = [
                "KeySalt": keySalt,
                "PrimaryKey": privateKey,
                "AddressKeys": [address],
                "Auth": passwordAuth.toDictionary()!
            ]

            return out
        }
    }
}
