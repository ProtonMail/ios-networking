//
//  MenuViewModel.swift
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
import PMCoreTranslation

class MenuViewModel {

    // MARK: - Public properties and methods

    struct Segment {
        let title: String
        let index: Int
    }

    let verifyMethods: [VerifyMethod]
    var verifySegments: [Segment] {
        var segments: [Segment] = []
        for (index, value) in verifyMethods.enumerated() {
            segments += [Segment(title: value.localizedTitle, index: index)]
        }
        return segments
    }

    init(methods: [VerifyMethod]) {
        self.verifyMethods = methods
    }

}

private extension VerifyMethod {
    var localizedTitle: String {
        switch self {
        case .sms:
            return CoreString._hv_sms_method_name
        case .email:
            return CoreString._hv_email_method_name
        case .captcha:
            return CoreString._hv_captha_method_name
        default:
            return ""
        }
    }
}
