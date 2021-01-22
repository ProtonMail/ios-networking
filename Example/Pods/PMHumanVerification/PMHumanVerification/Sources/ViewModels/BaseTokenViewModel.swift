//
//  BaseTokenViewModel.swift
//  ProtonMail - Created on 20/01/21.
//
//
//  Copyright (c) 2021 Proton Technologies AG
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
import PMCommon

struct TokenType {
    let destination: String?
    let verifyMethod: VerifyMethod?
    let token: String?
}

class BaseTokenViewModel {

    // MARK: - Private properties

    private var token: String?
    private var tokenMethod: VerifyMethod?

    // MARK: - Public properties and methods

    let apiService: APIService
    let startToken: String?
    var method: VerifyMethod = .captcha
    var destination: String = ""
    var onVerificationCodeBlock: ((@escaping SendVerificationCodeBlock) -> Void)?

    init(api: APIService, startToken: String?) {
        self.apiService = api
        self.startToken = startToken
    }

    func finalToken(token: String, complete: @escaping SendVerificationCodeBlock) {
        self.token = token
        self.tokenMethod = self.method
        onVerificationCodeBlock?({ (res, error) in
            complete(res, error)
        })
    }

    func getToken() -> TokenType {
        return TokenType(destination: self.destination, verifyMethod: tokenMethod, token: token)
    }
}
