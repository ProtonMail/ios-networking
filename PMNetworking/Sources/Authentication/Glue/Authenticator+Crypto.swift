////
////  Authenticator+Crypto.swift
////  PMAuthentication
////
////  Created on 11/03/2020.
////
////
////  Copyright (c) 2019 Proton Technologies AG
////
////  This file is part of ProtonMail.
////
////  ProtonMail is free software: you can redistribute it and/or modify
////  it under the terms of the GNU General Public License as published by
////  the Free Software Foundation, either version 3 of the License, or
////  (at your option) any later version.
////
////  ProtonMail is distributed in the hope that it will be useful,
////  but WITHOUT ANY WARRANTY; without even the implied warranty of
////  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
////  GNU General Public License for more details.
////
////  You should have received a copy of the GNU General Public License
////  along with ProtonMail.  If not, see <https://www.gnu.org/licenses/>.
//
//
//import Foundation
//import Crypto
//
///* IMPORTANT: this file adds explicit dependency on Crypto framework, do not add this file to SPM sources */
//public typealias Authenticator = GenericAuthenticator<Crypto.SrpAuth, Crypto.SrpProofs>
//
//extension SrpProofs: SrpProofsProtocol {}
//
//extension SrpAuth: SrpAuthProtocol {
//    public func generateProofs(of length: Int) throws -> AnyObject {
//        return try self.generateProofs(length)
//    }
//}
