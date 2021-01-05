//
//  SignupViewModel.swift
//  ProtonMail - Created on 1/18/16.
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

#if canImport(UIKit)
import UIKit
import PMCommon
import PMCoreTranslation

public struct TokenType {
    let destination: String?
    let verifyMethod: VerifyMethod?
    let token: String?
}

public protocol HumanCheckViewModel: class {
    var verifyTypes: [VerifyMethod] { get set }
    var type: VerifyMethod { get set }
    var supportURL: URL? { get }

    func finalToken(token: String, complete: @escaping SendVerificationCodeBlock)
    func close()
    func getToken() -> TokenType
    func setEmail(email: String)
    func getDestination() -> String
    func sendVerifyCode(_ type: VerifyMethod, complete: @escaping SendVerificationCodeBlock)
    func getTitle() -> String
    func getMsg() -> String
    func getCaptchaURL() -> URL
    func isValidCodeFormat(code: String) -> Bool
    func isValidEmail(email: String) -> Bool
}

 public class HumanCheckViewModelImpl: HumanCheckViewModel {

    public var onVerificationCodeBlock: ((@escaping SendVerificationCodeBlock) -> Void)?
    public var onCloseBlock: (() -> Void)?

    var token: String?
    var tokenType: VerifyMethod?

    public func finalToken(token: String, complete: @escaping SendVerificationCodeBlock) {
        self.token = token
        self.tokenType = self.type
        self.onVerificationCodeBlock?({ (res, error) in
            complete(res, error)
        })
    }

    public func close() {
        self.onCloseBlock?()
    }

    public func getToken() -> TokenType {
        return TokenType(destination: self.destination, verifyMethod: tokenType, token: token)
    }

    public func getTitle() -> String {
        if type == .sms {
            return String(format: CoreString._hv_verification_enter_sms_code, self.destination)
        } else if type == .email {
            return String(format: CoreString._hv_verification_enter_email_code, self.destination)
        } else {
            return ""
        }
    }

    public func getMsg() -> String {
        return String(format: CoreString._hv_verification_sent_banner, self.destination)
    }

    public func getCaptchaURL() -> URL {
        let host = apiService.doh.getCaptchaHostUrl()
        return URL(string: "https://secure.protonmail.com/captcha/captcha.html?token=\(startToken ?? "")&client=ios&host=\(host)")!
    }

    public var type: VerifyMethod = .captcha

    public var supportURL: URL? {
        return self.apiService.humanDelegate?.getSupportURL()
    }

    public func getDestination() -> String {
        return self.destination
    }

    public var verifyTypes: [VerifyMethod] = []
    var apiService: APIService
    var destination: String = ""
    let startToken: String?

    public init(types: [VerifyMethod], startToken: String?, api: APIService) {
        self.verifyTypes = types
        self.apiService = api
        self.startToken = startToken
    }

    public func setEmail(email: String) {
        self.destination = email
    }

    public func sendVerifyCode(_ type: VerifyMethod, complete: @escaping SendVerificationCodeBlock) {

        let newType: HumanVerificationToken.TokenType = type == .email ? .email : .sms
        let route = UserAPI.Router.code(type: newType, receiver: destination)
        self.apiService.exec(route: route) { (_, response) in
            if response.code != APIErrorCode.responseOK {
                complete(false, response.error)
            } else {
                complete(true, nil)
            }
        }
    }

    public func isValidCodeFormat(code: String) -> Bool {
        return code.sixDigits()
    }

    public func isValidEmail(email: String) -> Bool {
        return email.isValidEmail()
    }

}

#endif
