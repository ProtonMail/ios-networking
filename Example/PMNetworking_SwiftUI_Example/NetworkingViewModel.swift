//
//  NetworkingViewModel.swift
//  PMNetworking_SwiftUI_Example
//
//  Created by Greg on 22.01.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import SwiftUI
//import PMUICommon

class NetworkingViewModel: ObservableObject {
    
//    class DevDoHMail: DoH, ServerConfig {
//        var signupDomain: String = "proton.dev"
//        var defaultHost: String = "https://proton.dev"
//        var captchaHost: String = "proton.dev"
//        var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
//        var defaultPath: String = "/api"
//        static let `default` = try! DevDoHMail()
//    }
//
//    class BlueDoHMail: DoH, ServerConfig {
//        var signupDomain: String = "proton.blue"
//        var defaultHost: String = "https://protonmail.blue"
//        var captchaHost: String = "mail.protonmail.blue"
//        var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
//        var defaultPath: String = "/api"
//        static let `default` = try! BlueDoHMail()
//    }
//
//    class ProdDoHMail: DoH, ServerConfig {
//        var signupDomain: String = "protonmail.com"
//        var defaultHost: String = "https://api.protonmail.ch"
//        var captchaHost: String = "https://api.protonmail.ch"
//        var apiHost : String = "dmfygsltqojxxi33onvqws3bomnua.protonpro.xyz"
//        static let `default` = try! ProdDoHMail()
//    }
    
    var env = ["Dev env.", "Blue env.", "Prod env."]
    var selectedIndex: Int = 0 {
        didSet {
            print("Selected index: \(selectedIndex)")
        }
    }
    
    func humanVerificationUnauthAction() {
        print("Human verification")
    }
    
}

