//
//  UserAPI.swift
//  PMNetworking
//
//  Created by on 5/25/20.
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

// swiftlint:disable identifier_name todo

import Foundation

public typealias SendVerificationCodeBlock = (Bool, NSError?) -> Void

public struct HumanVerificationToken {
    let type: TokenType
    let token: String
    let input: String? // Email, phone number or catcha token

    public init(type: TokenType, token: String, input: String? = nil) {
        self.type = type
        self.token = token
        self.input = input
    }

    var fullValue: String {
        switch type {
        case .email, .sms:
            return "\(input ?? ""):\(token)"
        case .payment, .captcha:
            return token
        case .invite:
            return ""
        }
    }

    public enum TokenType: String, CaseIterable {
        case email
        case sms
        case invite
        case payment
        case captcha
        //    case coupon // Since this isn't compatible with IAP, this option can be safely ignored

        static func type(fromString: String) -> TokenType? {
            for value in TokenType.allCases where value.rawValue == fromString {
                return value
            }
            return nil
        }
    }
}

// Users API
// Doc: https://github.com/ProtonMail/Slim-API/blob/develop/api-spec/pm_api_users.md

public class UserAPI: APIClient {

    static let route: String = "/users"

    ///
    static let vpnType = 2

    /// default user route version
    static let v_user_default: Int = 3

    public enum Router: Request {
        case code(type: HumanVerificationToken.TokenType, receiver: String)
        case check(token: HumanVerificationToken)
        case checkUsername(String)
        case userInfo

        public var path: String {
            switch self {
            case .code:
                return route + "/code"
            case .check:
                return route + "/check"
            case .checkUsername(let username):
                return route + "/available?Name=" + username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            case .userInfo:
                return route
            }
        }

        public var isAuth: Bool {
            switch self {
            case .userInfo:
                return true
            case .code, .check:
                return false
            default:
                return false
            }
        }

        public var header: [String: Any] {
            return [:]
        }

        public var apiVersion: Int {
            switch self {
            case .code, .check, .checkUsername, .userInfo:
                return v_user_default
            }
        }

        public var method: HTTPMethod {
            switch self {
            case .checkUsername, .userInfo:
                return .get
            case  .code:
                return .post
            case .check:
                return .put
            }
        }

        public var parameters: [String: Any]? {
            switch self {
            case .code(let type, let receiver):
                let destinationType: String
                switch type {
                case .email:
                    destinationType = "Address"
                case .sms:
                    destinationType = "Phone"
                case .payment, .invite, .captcha:
                    fatalError("Wrong parameter used. Payment is not supported by code endpoint.")
                }
                let out: [String: Any] = [
                    "Type": type.rawValue,
                    "Destination": [
                        destinationType: receiver
                    ]
                ]
                return out
            case .check(let token):
                return [
                    "Token": "\(token.fullValue)",
                    "TokenType": token.type.rawValue,
                    "Type": vpnType
                ]
            default:
                return [:]
            }
        }
    }
}

public final class GetUserInfoResponse: Response {
    public var userInfo: UserInfo?

    public override func ParseResponse(_ response: [String: Any]!) -> Bool {
        guard let res = response["User"] as? [String: Any] else {
            return false
        }
        self.userInfo = UserInfo(response: res)
        return true
    }
}

public struct ShowImages: OptionSet {
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public let rawValue: Int
    // 0 for none, 1 for remote, 2 for embedded, 3 for remote and embedded (

    public static let none     = ShowImages([])
    public static let remote   = ShowImages(rawValue: 1 << 0) // auto load remote images
    public static let embedded = ShowImages(rawValue: 1 << 1) // auto load embedded images
}

public enum LinkOpeningMode: String {
    case confirmationAlert, openAtWill
}

@objc(UserInfo)
public final class UserInfo: NSObject {

    // 1.9.0 phone local cache
    public var language: String

    // 1.9.1 user object
    public var delinquent: Int
    public var role: Int
    public var maxSpace: Int64
    public var usedSpace: Int64
    public var maxUpload: Int64
    public var userId: String

    public var userKeys: [Key] // user key

    // 1.11.12 user object
    public var credit: Int
    public var currency: String

    // 1.9.1 mail settings
    public var displayName: String = ""
    public var defaultSignature: String = ""
    public var autoSaveContact: Int = 0
    public var showImages: ShowImages = .none
    public var autoShowRemote: Bool {
        return self.showImages.contains(.remote)
    }
    public var swipeLeft: Int = 3
    public var swipeRight: Int = 0

    public var linkConfirmation: LinkOpeningMode = .confirmationAlert

    public var attachPublicKey: Int = 0
    public var sign: Int = 0

    // 1.9.1 user settings
    public var notificationEmail: String = ""
    public var notify: Int = 0

    // 1.9.0 get from addresses route
    public var userAddresses: [Address] = [Address]()

    // 1.12.0
    public var passwordMode: Int = 1
    public var twoFactor: Int = 0

    // 2.0.0
    public var enableFolderColor: Int = 0
    public var inheritParentFolderColor: Int = 0
    /// 0: free user, > 0: paid user
    public var subscribed: Int = 0

    // 0 - threading, 1 - single message
    public var groupingMode: Int = 1

    public static func getDefault() -> UserInfo {
        return .init(maxSpace: 0, usedSpace: 0, language: "",
                     maxUpload: 0, role: 0, delinquent: 0,
                     keys: nil, userId: "", linkConfirmation: 0,
                     credit: 0, currency: "", subscribed: 0)
    }

    public var isPaid: Bool {
        return self.role > 0 ? true : false
    }

    // init from cache
    public required init(
        displayName: String?, maxSpace: Int64?, notificationEmail: String?, signature: String?,
        usedSpace: Int64?, userAddresses: [Address]?,
        autoSC: Int?, language: String?, maxUpload: Int64?, notify: Int?, showImage: Int?,  // v1.0.8
        swipeL: Int?, swipeR: Int?,  // v1.1.4
        role: Int?,
        delinquent: Int?,
        keys: [Key]?,
        userId: String?,
        sign: Int?,
        attachPublicKey: Int?,
        linkConfirmation: String?,
        credit: Int?,
        currency: String?,
        pwdMode: Int?,
        twoFA: Int?,
        enableFolderColor: Int?,
        inheritParentFolderColor: Int?,
        subscribed: Int?) {
        self.maxSpace = maxSpace ?? 0
        self.usedSpace = usedSpace ?? 0
        self.language = language ?? "en_US"
        self.maxUpload = maxUpload ?? 0
        self.role = role ?? 0
        self.delinquent = delinquent ?? 0
        self.userKeys = keys ?? [Key]()
        self.userId = userId ?? ""

        // get from user settings
        self.notificationEmail = notificationEmail ?? ""
        self.notify = notify ?? 0

        // get from mail settings
        self.displayName = displayName ?? ""
        self.defaultSignature = signature ?? ""
        self.autoSaveContact  = autoSC ?? 0
        self.showImages = ShowImages(rawValue: showImage ?? 0)
        self.swipeLeft = swipeL ?? 3
        self.swipeRight = swipeR ?? 0

        self.sign = sign ?? 0
        self.attachPublicKey = attachPublicKey ?? 0

        // addresses
        self.userAddresses = userAddresses ?? [Address]()

        self.credit = credit ?? 0
        self.currency = currency ?? "USD"

        self.passwordMode = pwdMode ?? 1
        self.twoFactor = twoFA ?? 0

        self.enableFolderColor = enableFolderColor ?? 0
        self.inheritParentFolderColor = inheritParentFolderColor ?? 0
        self.subscribed = subscribed ?? 0
        if let value = linkConfirmation, let mode = LinkOpeningMode(rawValue: value) {
            self.linkConfirmation = mode
        }
    }

    // init from api
    public required init(maxSpace: Int64?, usedSpace: Int64?,
                         language: String?, maxUpload: Int64?,
                         role: Int?,
                         delinquent: Int?,
                         keys: [Key]?,
                         userId: String?,
                         linkConfirmation: Int?,
                         credit: Int?,
                         currency: String?,
                         subscribed: Int?) {
        self.maxSpace = maxSpace ?? 0
        self.usedSpace = usedSpace ?? 0
        self.language = language ?? "en_US"
        self.maxUpload = maxUpload ?? 0
        self.role = role ?? 0
        self.delinquent = delinquent ?? 0
        self.userId = userId ?? ""
        self.userKeys = keys ?? [Key]()
        self.linkConfirmation = linkConfirmation == 0 ? .openAtWill : .confirmationAlert
        self.credit = credit ?? 0
        self.currency = currency ?? "USD"
        self.subscribed = subscribed ?? 0
    }

    /// Update user addresses
    ///
    /// - Parameter addresses: new addresses
    public func set(addresses: [Address]) {
        self.userAddresses = addresses
    }

    /// set User, copy the data from input user object
    ///
    /// - Parameter userinfo: New user info
    public func set(userinfo: UserInfo) {
        self.maxSpace = userinfo.maxSpace
        self.usedSpace = userinfo.usedSpace
        self.language = userinfo.language
        self.maxUpload = userinfo.maxUpload
        self.role = userinfo.role
        self.delinquent = userinfo.delinquent
        self.userId = userinfo.userId
        self.linkConfirmation = userinfo.linkConfirmation
        self.userKeys = userinfo.userKeys
    }

    public func parse(userSettings: [String: Any]?) {
        if let settings = userSettings {
            if let email = settings["Email"] as? [String: Any] {
                self.notificationEmail = email["Value"] as? String ?? ""
                self.notify = email["Notify"] as? Int ?? 0
            }

            if let pwdMode = settings["PasswordMode"] as? Int {
                self.passwordMode = pwdMode
            } else {
                if let pwd = settings["Password"] as? [String: Any] {
                    if let mode = pwd["Mode"] as? Int {
                        self.passwordMode = mode
                    }
                }
            }

            if let twoFA = settings["2FA"]  as? [String: Any] {
                self.twoFactor = twoFA["Enabled"] as? Int ?? 0
            }
        }
    }

    public func parse(mailSettings: [String: Any]?) {
        if let settings = mailSettings {
            self.displayName = settings["DisplayName"] as? String ?? "'"
            self.defaultSignature = settings["Signature"] as? String ?? ""
            self.autoSaveContact  = settings["AutoSaveContacts"] as? Int ?? 0
            self.showImages = ShowImages(rawValue: settings["ShowImages"] as? Int ?? 0)
            self.swipeLeft = settings["SwipeLeft"] as? Int ?? 3
            self.swipeRight = settings["SwipeRight"] as? Int ?? 0
            self.linkConfirmation = settings["ConfirmLink"] as? Int == 0 ? .openAtWill : .confirmationAlert

            self.attachPublicKey = settings["AttachPublicKey"] as? Int ?? 0
            self.sign = settings["Sign"] as? Int ?? 0
            self.enableFolderColor = settings["EnableFolderColor"] as? Int ?? 0
            self.inheritParentFolderColor = settings["InheritParentFolderColor"] as? Int ?? 0
            self.groupingMode = settings["ViewMode"] as? Int ?? 1
        }
    }

    public func firstUserKey() -> Key? {
        if self.userKeys.count > 0 {
            return self.userKeys[0]
        }
        return nil
    }

    public func getPrivateKey(by keyID: String?) -> String? {
        if let keyID = keyID {
            for userkey in self.userKeys where userkey.key_id == keyID {
                return userkey.private_key
            }
        }
        return firstUserKey()?.private_key
    }

    public var newSchema: Bool {
        for key in addressKeys where key.newSchema {
            return true
        }
        return false
    }

    public var addressKeys: [Key] {
        var out = [PMCommon.Key]()
        for addr in userAddresses {
            for key in addr.keys {
                out.append(key)
            }
        }
        return out
    }

//    var addressPrivateKeys: Data {
////        var out = Data()
////        var error: NSError?
////        for addr in userAddresses {
////            for key in addr.keys {
////                if let privK = ArmorUnarmor(key.private_key, &error) {
////                    out.append(privK)
////                }
////            }
////        }
////        return out
//        return Data()
//    }

//    var firstUserPublicKey: String? {
//        if userKeys.count > 0 {
//            for k in userKeys {
//                return k.publicKey
//            }
//        }
//        return nil
//    }

    public func getAddressPrivKey(address_id: String) -> String {
        let addr = userAddresses.indexOfAddress(address_id) ?? userAddresses.defaultSendAddress()
        return addr?.keys.first?.private_key ?? ""
    }

    public func getAddressKey(address_id: String) -> Key? {
        let addr = userAddresses.indexOfAddress(address_id) ?? userAddresses.defaultSendAddress()
        return addr?.keys.first
    }

    /// Get all keys that belong to the given address id
    /// - Parameter address_id: Address id
    /// - Returns: Keys of the given address id. nil means can't find the address
    public func getAllAddressKey(address_id: String) -> [Key]? {
        guard let addr = userAddresses.indexOfAddress(address_id) else {
            return nil
        }
        return addr.keys
    }
}

extension UserInfo {
    /// Initializes the UserInfo with the response data
    public convenience init(response: [String: Any]) {
        var uKeys: [Key] = [Key]()
        if let user_keys = response["Keys"] as? [[String: Any]] {
            for key_res in user_keys {
                uKeys.append(Key(
                    key_id: key_res["ID"] as? String,
                    private_key: key_res["PrivateKey"] as? String,
                    token: key_res["Token"] as? String,
                    signature: key_res["Signature"] as? String,
                    activation: key_res["Activation"] as? String,
                    isupdated: false))
            }
        }
        let userId = response["ID"] as? String
        let usedS = response["UsedSpace"] as? NSNumber
        let maxS = response["MaxSpace"] as? NSNumber
        let credit = response["Credit"] as? NSNumber
        let currency = response["Currency"] as? String
        let subscribed = response["Subscribed"] as? Int
        self.init(
            maxSpace: maxS?.int64Value,
            usedSpace: usedS?.int64Value,
            language: response["Language"] as? String,
            maxUpload: response["MaxUpload"] as? Int64,
            role: response["Role"] as? Int,
            delinquent: response["Delinquent"] as? Int,
            keys: uKeys,
            userId: userId,
            linkConfirmation: response["ConfirmLink"] as? Int,
            credit: credit?.intValue,
            currency: currency,
            subscribed: subscribed
        )
    }
}

// MARK: - NSCoding
extension UserInfo: NSCoding {

    fileprivate struct CoderKey {
        static let displayName = "displayName"
        static let maxSpace = "maxSpace"
        static let notificationEmail = "notificationEmail"
        static let signature = "signature"
        static let usedSpace = "usedSpace"
        static let userStatus = "userStatus"
        static let userAddress = "userAddresses"

        static let autoSaveContact = "autoSaveContact"
        static let language = "language"
        static let maxUpload = "maxUpload"
        static let notify = "notify"
        static let showImages = "showImages"

        static let swipeLeft = "swipeLeft"
        static let swipeRight = "swipeRight"

        static let role = "role"

        static let delinquent = "delinquent"

        static let userKeys = "userKeys"
        static let userId = "userId"

        static let attachPublicKey = "attachPublicKey"
        static let sign = "sign"

        static let linkConfirmation = "linkConfirmation"

        static let credit = "credit"
        static let currency = "currency"
        static let subscribed = "subscribed"

        static let pwdMode = "passwordMode"
        static let twoFA = "2faStatus"

        static let enableFolderColor = "enableFolderColor"
        static let inheritParentFolderColor = "inheritParentFolderColor"
    }

    public func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    static public func unarchive(_ data: Data?) -> UserInfo? {
        guard let data = data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? UserInfo
    }

    public convenience init(coder aDecoder: NSCoder) {
        self.init(
            displayName: aDecoder.decodeStringForKey(CoderKey.displayName),
            maxSpace: aDecoder.decodeInt64(forKey: CoderKey.maxSpace),
            notificationEmail: aDecoder.decodeStringForKey(CoderKey.notificationEmail),
            signature: aDecoder.decodeStringForKey(CoderKey.signature),
            usedSpace: aDecoder.decodeInt64(forKey: CoderKey.usedSpace),
            userAddresses: aDecoder.decodeObject(forKey: CoderKey.userAddress) as? [Address],

            autoSC: aDecoder.decodeInteger(forKey: CoderKey.autoSaveContact),
            language: aDecoder.decodeStringForKey(CoderKey.language),
            maxUpload: aDecoder.decodeInt64(forKey: CoderKey.maxUpload),
            notify: aDecoder.decodeInteger(forKey: CoderKey.notify),
            showImage: aDecoder.decodeInteger(forKey: CoderKey.showImages),

            swipeL: aDecoder.decodeInteger(forKey: CoderKey.swipeLeft),
            swipeR: aDecoder.decodeInteger(forKey: CoderKey.swipeRight),

            role: aDecoder.decodeInteger(forKey: CoderKey.role),

            delinquent: aDecoder.decodeInteger(forKey: CoderKey.delinquent),

            keys: aDecoder.decodeObject(forKey: CoderKey.userKeys) as? [Key],
            userId: aDecoder.decodeStringForKey(CoderKey.userId),
            sign: aDecoder.decodeInteger(forKey: CoderKey.sign),
            attachPublicKey: aDecoder.decodeInteger(forKey: CoderKey.attachPublicKey),

            linkConfirmation: aDecoder.decodeStringForKey(CoderKey.linkConfirmation),

            credit: aDecoder.decodeInteger(forKey: CoderKey.credit),
            currency: aDecoder.decodeStringForKey(CoderKey.currency),

            pwdMode: aDecoder.decodeInteger(forKey: CoderKey.pwdMode),
            twoFA: aDecoder.decodeInteger(forKey: CoderKey.twoFA),
            enableFolderColor: aDecoder.decodeInteger(forKey: CoderKey.enableFolderColor),
            inheritParentFolderColor: aDecoder.decodeInteger(forKey: CoderKey.inheritParentFolderColor),
            subscribed: aDecoder.decodeInteger(forKey: CoderKey.subscribed)
        )
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(maxSpace, forKey: CoderKey.maxSpace)
        aCoder.encode(notificationEmail, forKey: CoderKey.notificationEmail)
        aCoder.encode(usedSpace, forKey: CoderKey.usedSpace)
        aCoder.encode(userAddresses, forKey: CoderKey.userAddress)

        aCoder.encode(language, forKey: CoderKey.language)
        aCoder.encode(maxUpload, forKey: CoderKey.maxUpload)
        aCoder.encode(notify, forKey: CoderKey.notify)

        aCoder.encode(role, forKey: CoderKey.role)
        aCoder.encode(delinquent, forKey: CoderKey.delinquent)
        aCoder.encode(userKeys, forKey: CoderKey.userKeys)

        // get from mail settings
        aCoder.encode(displayName, forKey: CoderKey.displayName)
        aCoder.encode(defaultSignature, forKey: CoderKey.signature)
        aCoder.encode(autoSaveContact, forKey: CoderKey.autoSaveContact)
        aCoder.encode(showImages.rawValue, forKey: CoderKey.showImages)
        aCoder.encode(swipeLeft, forKey: CoderKey.swipeLeft)
        aCoder.encode(swipeRight, forKey: CoderKey.swipeRight)
        aCoder.encode(userId, forKey: CoderKey.userId)
        aCoder.encode(enableFolderColor, forKey: CoderKey.enableFolderColor)
        aCoder.encode(inheritParentFolderColor, forKey: CoderKey.inheritParentFolderColor)

        aCoder.encode(sign, forKey: CoderKey.sign)
        aCoder.encode(attachPublicKey, forKey: CoderKey.attachPublicKey)

        aCoder.encode(linkConfirmation.rawValue, forKey: CoderKey.linkConfirmation)

        aCoder.encode(credit, forKey: CoderKey.credit)
        aCoder.encode(currency, forKey: CoderKey.currency)
        aCoder.encode(subscribed, forKey: CoderKey.subscribed)

        aCoder.encode(passwordMode, forKey: CoderKey.pwdMode)
        aCoder.encode(twoFactor, forKey: CoderKey.twoFA)
    }
}

@objc(Key)
final public class Key: NSObject {
    public let key_id: String
    public var private_key: String
    public var is_updated: Bool = false
    public var keyflags: Int = 0

    // key migration step 1 08/01/2019
    public var token: String?
    public var signature: String?

    // old activetion flow
    public var activation: String? // armed pgp msg, token encrypted by user's public key and

    public required init(key_id: String?, private_key: String?,
                         token: String?, signature: String?, activation: String?,
                         isupdated: Bool) {
        self.key_id = key_id ?? ""
        self.private_key = private_key ?? ""
        self.is_updated = isupdated

        self.token = token
        self.signature = signature

        self.activation = activation
    }

    public var newSchema: Bool {
        return signature != nil
    }
}

extension Key: NSCoding {

    private struct CoderKey {
        static let keyID          = "keyID"
        static let privateKey     = "privateKey"
        static let fingerprintKey = "fingerprintKey"

        static let Token     = "Key.Token"
        static let Signature = "Key.Signature"
        //
        static let Activation = "Key.Activation"
    }

    static func unarchive(_ data: Data?) -> [Key]? {
        guard let data = data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? [Key]
    }

    public convenience init(coder aDecoder: NSCoder) {
        self.init(
            key_id: aDecoder.decodeStringForKey(CoderKey.keyID),
            private_key: aDecoder.decodeStringForKey(CoderKey.privateKey),
            token: aDecoder.decodeStringForKey(CoderKey.Token),
            signature: aDecoder.decodeStringForKey(CoderKey.Signature),
            activation: aDecoder.decodeStringForKey(CoderKey.Activation),
            isupdated: false)
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(key_id, forKey: CoderKey.keyID)
        aCoder.encode(private_key, forKey: CoderKey.privateKey)

        // new added
        aCoder.encode(token, forKey: CoderKey.Token)
        aCoder.encode(signature, forKey: CoderKey.Signature)

        //
        aCoder.encode(activation, forKey: CoderKey.Activation)

        // TODO:: fingerprintKey is deprecated, need to "remove and clean"
        aCoder.encode("", forKey: CoderKey.fingerprintKey)
    }
}

extension Array where Element: Key {
    func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

//    var binPrivKeys: Data {
////        var out = Data()
////        var error: NSError?
////        for key in self {
////            if let privK = ArmorUnarmor(key.private_key, &error) {
////                out.append(privK)
////            }
////        }
////        return out
//        return Data()
//    }

    public var newSchema: Bool {
        for key in self where key.newSchema {
            return true
        }
        return false
    }

}

@objc(Address)
final public class Address: NSObject {
    public let address_id: String
    public let email: String   // email address name
    public let status: Int    // 0 is disabled, 1 is enabled, can be set by user
    public let type: Int      // 1 is original PM, 2 is PM alias, 3 is custom domain address
    public let receive: Int    // 1 is active address (Status =1 and has key), 0 is inactive (cannot send or receive)
    public var order: Int      // address order
    // 0 means you can’t send with it 1 means you can pm.me addresses have Send 0 for free users, for instance so do addresses without keys
    public var send: Int
    public let keys: [Key]
    public var display_name: String
    public var signature: String

    public required init(addressid: String?,
                         email: String?,
                         order: Int?,
                         receive: Int?,
                         display_name: String?,
                         signature: String?,
                         keys: [Key]?,
                         status: Int?,
                         type: Int?,
                         send: Int?) {
        self.address_id = addressid ?? ""
        self.email = email ?? ""
        self.receive = receive ?? 0
        self.display_name = display_name ?? ""
        self.signature = signature ?? ""
        self.keys = keys ?? [Key]()

        self.status = status ?? 0
        self.type = type ?? 0

        self.send = send ?? 0
        self.order = order ?? 0
    }

}

// MARK: - TODO:: we'd better move to Codable or at least NSSecureCoding when will happen to refactor this part of app from Anatoly
extension Address: NSCoding {
    public func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }

    static public func unarchive(_ data: Data?) -> Address? {
        guard let data = data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Address
    }

    // the keys all messed up but it works ( don't copy paste there looks really bad)
    fileprivate struct CoderKey {
        static let addressID    = "displayName"
        static let email        = "maxSpace"
        static let order        = "notificationEmail"
        static let receive      = "privateKey"
        static let mailbox      = "publicKey"
        static let display_name = "signature"
        static let signature    = "usedSpace"
        static let keys         = "userKeys"

        static let addressStatus = "addressStatus"
        static let addressType   = "addressType"
        static let addressSend   = "addressSendStatus"
    }

    public convenience init(coder aDecoder: NSCoder) {
        self.init(
            addressid: aDecoder.decodeStringForKey(CoderKey.addressID),
            email: aDecoder.decodeStringForKey(CoderKey.email),
            order: aDecoder.decodeInteger(forKey: CoderKey.order),
            receive: aDecoder.decodeInteger(forKey: CoderKey.receive),
            display_name: aDecoder.decodeStringForKey(CoderKey.display_name),
            signature: aDecoder.decodeStringForKey(CoderKey.signature),
            keys: aDecoder.decodeObject(forKey: CoderKey.keys) as?  [Key],

            status: aDecoder.decodeInteger(forKey: CoderKey.addressStatus),
            type: aDecoder.decodeInteger(forKey: CoderKey.addressType),
            send: aDecoder.decodeInteger(forKey: CoderKey.addressSend)
        )
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(address_id, forKey: CoderKey.addressID)
        aCoder.encode(email, forKey: CoderKey.email)
        aCoder.encode(order, forKey: CoderKey.order)
        aCoder.encode(receive, forKey: CoderKey.receive)
        aCoder.encode(display_name, forKey: CoderKey.display_name)
        aCoder.encode(signature, forKey: CoderKey.signature)
        aCoder.encode(keys, forKey: CoderKey.keys)

        aCoder.encode(status, forKey: CoderKey.addressStatus)
        aCoder.encode(type, forKey: CoderKey.addressType)

        aCoder.encode(send, forKey: CoderKey.addressSend)
    }
}

extension Array where Element: Address {
    public func defaultAddress() -> Address? {
        for addr in self {
            if addr.status == 1 && addr.receive == 1 {
                return addr
            }
        }
        return nil
    }

    public func defaultSendAddress() -> Address? {
        for addr in self {
            if addr.status == 1 && addr.receive == 1 && addr.send == 1 {
                return addr
            }
        }
        return nil
    }

    public func indexOfAddress(_ addressid: String) -> Address? {
        for addr in self {
            if addr.status == 1 && addr.receive == 1 && addr.address_id == addressid {
                return addr
            }
        }
        return nil
    }

    public func getAddressOrder() -> [String] {
        let ids = self.map { $0.address_id }
        return ids
    }

    func getAddressNewOrder() -> [Int] {
        let ids = self.map { $0.order }
        return ids
    }

    public func toKeys() -> [Key] {
        var out_array = [Key]()
        for i in 0 ..< self.count {
            let addr = self[i]
            for k in addr.keys {
                out_array.append(k)
            }
        }
        return out_array
    }
}
extension NSCoder {

    func decodeStringForKey(_ key: String) -> String? {
        return decodeObject(forKey: key) as? String
    }
}
