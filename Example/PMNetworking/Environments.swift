//
//  Environment.swift
//  PMNetworking
//
//  Created on 22/01/2021.
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

import PMCommon

class BlackDoHMail: DoH, ServerConfig {
    var signupDomain: String = ObfuscatedConstants.blackSignupDomain
    var defaultHost: String = ObfuscatedConstants.blackDefaultHost
    var captchaHost: String = ObfuscatedConstants.blackCaptchaHost
    var apiHost: String = ObfuscatedConstants.blackApiHost
    var defaultPath: String = ObfuscatedConstants.blackDefaultPath
    static let `default` = try! BlackDoHMail()
}

class DaltonBlackDoHMail: DoH, ServerConfig {
    var signupDomain: String = ObfuscatedConstants.daltonBlackSignupDomain
    var defaultHost: String = ObfuscatedConstants.daltonBlackDefaultHost
    var captchaHost: String = ObfuscatedConstants.daltonBlackCaptchaHost
    var apiHost: String = ObfuscatedConstants.daltonBlackApiHost
    var defaultPath: String = ObfuscatedConstants.daltonBlackDefaultPath
    static let `default` = try! DaltonBlackDoHMail()
}

class DevDoHMail: DoH, ServerConfig {
    var signupDomain: String = ObfuscatedConstants.devSignupDomain
    var defaultHost: String = ObfuscatedConstants.devDefaultHost
    var captchaHost: String = ObfuscatedConstants.devCaptchaHost
    var apiHost: String = ObfuscatedConstants.devApiHost
    var defaultPath: String = ObfuscatedConstants.devDefaultPath
    static let `default` = try! DevDoHMail()
}

class ProdDoHMail: DoH, ServerConfig {
    var signupDomain: String = "protonmail.com"
    var defaultHost: String = "https://api.protonmail.ch"
    var captchaHost: String = "https://api.protonmail.ch"
    var apiHost: String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    static let `default` = try! ProdDoHMail()
}
