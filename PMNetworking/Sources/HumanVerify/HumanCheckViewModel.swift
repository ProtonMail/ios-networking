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

////typealias CheckUserNameBlock = (Result<CheckUserExistResponse.AvailabilityStatus>) -> Void
//typealias CreateUserBlock = (Bool, Bool, String, Error?) -> Void
//typealias GenerateKey = (Bool, String?, NSError?) -> Void
//typealias SendVerificationCodeBlock = (Bool, NSError?) -> Void
//
//protocol SignupViewModelDelegate{
//    func verificationCodeChanged(_ viewModel : SignupViewModel, code : String!)
//}
//
protocol ViewModelProtocolBase : AnyObject {
    func setModel(vm: Any)
    func inactiveViewModel() -> Void
}

protocol ViewModelProtocol : ViewModelProtocolBase {
    /// typedefine - view model -- if the class name defined in set function. the sub class could ignore viewModelType
    associatedtype viewModelType
    
    func set(viewModel: viewModelType) -> Void
}


extension ViewModelProtocol {
    func setModel(vm: Any) {
        guard let viewModel = vm as? viewModelType else {
            fatalError("This view model type doesn't match") //this shouldn't happend
        }
        self.set(viewModel: viewModel)
    }
    /// optional
    func inactiveViewModel() { 
    }
}

//public enum VerifyCodeType : Int {
//    case email = 0
//    case recaptcha = 1
//    case sms = 2
//    var toString : String {
//        get {
//            switch(self) {
//            case .email:
//                return "Email"
//            case .recaptcha:
//                return "Captcha"
//            case .sms:
//                return "SMS"
//            }
//        }
//    }
//}


public protocol HumanCheckViewModel : class {
    var verifyTypes : [VerifyMethod] { get set }
    
    //    var captcha_token : String
    //    var client_name : String
    //    var host_url: String
    func finalToken(token: String)
    func getToken() -> (VerifyMethod?, String?)
    
    var type: VerifyMethod {get set}
    func setEmail(email:String)
    func getDestination() -> String
    func sendVerifyCode(_ type: VerifyMethod, complete: SendVerificationCodeBlock)
    
    func getTitle() -> String
    func getMsg() -> String
}

//typealias AvailableDomainsComplete = ([String]) -> Void
 public class HumanCheckViewModelImpl : HumanCheckViewModel {
    
    public var onDoneBlock : ((Bool) -> Void)?
    
    var token : String?
    var tokenType : VerifyMethod?
    public func finalToken(token: String) {
        self.token = token
        self.tokenType = self.type
        self.onDoneBlock?(true)
    }
    public func getToken() -> (VerifyMethod?, String?) {
        return (tokenType, token)
    }
    
    public func getTitle() -> String {
        if type == .sms {
            return "Enter the verification code that was sent to \(self.destination)"
        } else if type == .email {
            return "Enter the verification code that was sent to \(self.destination). If you don't find the email in your inbox, please check your spam folder."
        } else {
            return ""
        }
    }
    
    public func getMsg() -> String {
        return "Code sent to \(self.destination)"
    }
    
    public var type: VerifyMethod = .captcha
    
    public func getDestination() -> String {
        return self.destination
    }
    
    public var verifyTypes: [VerifyMethod] = []
    var apiService: APIService
    var destination: String = ""
    
    public init(types: [VerifyMethod], api: APIService) {
        self.verifyTypes = types
        self.apiService = api
    }
    public func setEmail(email: String) {
        self.destination = email
    }
    
    public func sendVerifyCode(_ type: VerifyMethod, complete: SendVerificationCodeBlock) {
        
        let t : HumanVerificationToken.TokenType = type == .email ? .email : .sms
        let route = UserAPI.Router.code(type: t, receiver: destination)
        self.apiService.exec(route: route) { (task, response) in
            if response.code != 1000 { //} !hasError {
                //self.lastSendTime = Date()
            } else {
                print("200 get code")
            }
            
           
            //complete(!hasError, response?.error)
        }
    }
    
    
    //    func setDelegate (_ delegate: SignupViewModelDelegate?) {
    //        fatalError("This method must be overridden")
    //    }
    
    //    func checkUserName(_ username: String, complete: CheckUserNameBlock!) -> Void {
    //        fatalError("This method must be overridden")
    //    }
    
    //    func sendVerifyCode (_ type: VerifyCodeType, complete: SendVerificationCodeBlock!) -> Void {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    //
    //    func setRecaptchaToken (_ token : String, isExpired : Bool ) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setPickedUserName (_ username: String, domain:String) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func isTokenOk() -> Bool {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func createNewUser(_ complete :@escaping CreateUserBlock) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func generateKey(_ complete :@escaping GenerateKey) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setRecovery(_ receiveNews:Bool, email : String, displayName : String) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setCodeEmail(_ email : String) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setCodePhone(_ phone : String) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setEmailVerifyCode(_ code: String) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setPhoneVerifyCode (_ code: String) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setSinglePassword(_ password: String) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setAgreePolicy(_ isAgree : Bool) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func getTimerSet () -> Int {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func getCurrentBit() -> Int {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func setBit(_ bit: Int) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func fetchDirect(_ res : @escaping (_ directs:[String]) -> Void) {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func getDirect() -> [String] {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func getDomains(_ complete : @escaping AvailableDomainsComplete) -> Void {
    //        fatalError("This method must be overridden")
    //    }
    //
    //    func isAccountManager() -> Bool {
    //        return false
    //    }
}
#endif
