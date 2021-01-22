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

///Defind your doh settings

class DevDoHMail: DoH, ServerConfig {
    //defind your signup domain
    var signupDomain: String = "proton.dev"
    //defind your default host
    var defaultHost: String = "https://proton.dev"
    //defind your default captcha host
    var captchaHost: String = "proton.dev"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //defind your default path
    var defaultPath: String = "/api"
    //singleton
    static let `default` = try! DevDoHMail()
}

class BlueDoHMail: DoH, ServerConfig {
    //defind your signup domain
    var signupDomain: String = "proton.blue"
    //defind your default host
    var defaultHost: String = "https://protonmail.blue"
    //defind your default captcha host
    var captchaHost: String = "mail.protonmail.blue"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //defind your default path
    var defaultPath: String = "/api"
    //singleton
    static let `default` = try! BlueDoHMail()
}

class ProdDoHMail: DoH, ServerConfig {
    //defind your signup domain
    var signupDomain: String = "protonmail.com"
    //defind your default host
    var defaultHost: String = "https://api.protonmail.ch"
    //defind your default captcha host
    var captchaHost: String = "https://api.protonmail.ch"
    //defind your query host
    var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
    //singleton
    static let `default` = try! ProdDoHMail()
}
