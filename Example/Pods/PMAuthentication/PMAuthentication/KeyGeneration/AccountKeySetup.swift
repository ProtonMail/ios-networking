//
//  AccountKeySetup.swift
//  PMAuthentication
//
//  Created by Igor Kulman on 05.01.2021.
//  Copyright © 2021 ProtonMail. All rights reserved.
//

import Crypto
import Foundation

final class AccountKeySetup {
    private enum PasswordError: Error {
        case hashEmpty
        case hashEmptyEncode
        case hashSizeWrong
    }

    struct GeneratedAccountKey {
        let cryptoKey: CryptoKey
        let passwordSalt: Data
        let password: String
        let armoredKey: String
    }

    func generateAccountKey(keyName: String, email: String, password: String) throws -> GeneratedAccountKey {
        var error: NSError?

        // generate key salt 128 bits
        // CryptoRandomToken accept the size in bytes for some reason so alwas divide by 8
        guard let newPasswordSalt: Data = CryptoRandomToken(16, &error) else {
            throw error ?? KeySetupError.randomTokenGenerationFailed
        }

        //generate key hashed password.
        let newHashedPassword = hashPassword(password, salt: newPasswordSalt)

        guard let passwordLessKey = CryptoGenerateKey(keyName, email, "rsa", 2048, &error) else {
            throw error ?? KeySetupError.keyGenerationFailed
        }
        let key = try passwordLessKey.lock(newHashedPassword.data(using: .utf8))
        let armoredKey = key.armor(&error)
        return GeneratedAccountKey(cryptoKey: key, passwordSalt: newPasswordSalt, password: newHashedPassword, armoredKey: armoredKey)
    }

    func setupSetupKeysRoute(password: String, key: GeneratedAccountKey, modulus: String, modulusId: String, addressId: String) throws -> AuthService.SetupKeysEndpoint {
        var error: NSError?

        // for the login password needs to set 80 bits
        // CryptoRandomToken accept the size in bytes for some reason so alwas divide by 8
        guard let new_salt_for_key: Data = CryptoRandomToken(10, &error) else {
            throw error ?? KeySetupError.randomTokenGenerationFailed
        }

        //generate new verifier
        guard let auth_for_key = try SrpAuthForVerifier(password, modulus, new_salt_for_key) else {
            throw KeySetupError.cantHashPassword
        }

        let verifier_for_key = try auth_for_key.generateVerifier(2048)

        let pwd_auth = PasswordAuth(modulus_id: modulusId, salt: new_salt_for_key.encodeBase64(), verifer: verifier_for_key.encodeBase64())

        let unlockedKey = try key.cryptoKey.unlock(key.password.data(using: .utf8))
        guard let keyRing = CryptoKeyRing(unlockedKey) else {
            throw KeySetupError.keyRingGenerationFailed
        }

        let fingerprint = key.cryptoKey.getFingerprint()

        let keylist: [[String: Any]] = [[
            "Fingerprint": fingerprint,
            "Primary": 1,
            "Flags": 3
        ]]

        let jsonKeylist = keylist.json()
        let message = CryptoNewPlainMessageFromString(jsonKeylist)
        let signature = try keyRing.signDetached(message)
        let signed = signature.getArmored(&error)
        let signedKeyList: [String: Any] = [
            "Data": jsonKeylist,
            "Signature": signed
        ]

        return AuthService.SetupKeysEndpoint(addressID: addressId, privateKey: key.armoredKey, signedKeyList: signedKeyList, keySalt: key.passwordSalt.encodeBase64(), passwordAuth: pwd_auth)
    }

    func hashPassword(_ password: String, salt: Data) -> String {
        let byteArray = NSMutableData()
        byteArray.append(salt)
        let source = NSData(data: byteArray as Data) as Data
        let encodedSalt = JKBCrypt.based64DotSlash(source)
        do {
            let out = try bcrypt(password, salt: encodedSalt)
            let index = out.index(out.startIndex, offsetBy: 29)
            let outStr = String(out[index...])
            return outStr
        } catch PasswordError.hashEmpty {
            // check error
        } catch PasswordError.hashSizeWrong {
            // check error
        } catch {
            // check error
        }
        return ""
    }

    func bcrypt(_ password: String, salt: String) throws -> String {
        let real_salt = "$2a$10$" + salt

        //backup plan when native bcrypt return empty string
        if let out = JKBCrypt.hashPassword(password, withSalt: real_salt), !out.isEmpty {
            let size = out.count
            if size > 4 {
                let index = out.index(out.startIndex, offsetBy: 4)
                return "$2y$" + String(out[index...])
            } else {
                throw PasswordError.hashSizeWrong
            }
        }
        throw PasswordError.hashEmpty
    }
}
