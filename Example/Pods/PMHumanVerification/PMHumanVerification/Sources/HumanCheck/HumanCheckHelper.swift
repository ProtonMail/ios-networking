//
//  HumanCheckHelper.swift
//  ProtonMail - Created on 2/1/16.
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
import PMUICommon

public class HumanCheckHelper: HumanVerifyDelegate {
    fileprivate let navController: UINavigationController?
    fileprivate weak var responseDelegate: HumanVerifyResponseDelegate?
    fileprivate let apiService: APIService
    fileprivate let supportURL: URL
    internal var viewModel: HumanCheckViewModelImpl?
    
    public init(apiService: APIService, supportURL: URL, navigationController: UINavigationController? = nil, responseDelegate: HumanVerifyResponseDelegate? = nil) {
        self.apiService = apiService
        self.supportURL = supportURL
        self.navController = navigationController
        self.responseDelegate = responseDelegate
    }

    public func onHumanVerify(methods: [VerifyMethod], completion: (@escaping (HumanVerifyHeader, HumanVerifyIsClosed, SendVerificationCodeBlock?) -> (Void))) {
        viewModel = HumanCheckViewModelImpl(types: methods, api: apiService)
        guard let vm = viewModel else { return }
        let coordinator = HumanCheckMenuCoordinator(nav: navController, vm: vm,
                                                    services: ServiceFactory.default)
        coordinator?.start()
        self.responseDelegate?.onHumanVerifyStart()
        
        vm.onVerificationCodeBlock = { verificationCodeBlock in
            let (dest, type, token) = vm.getToken()
            let client = TestApiClient(api: self.apiService)
            let route = client.triggerHumanVerifyRoute(destination: dest, type: type, token: token)
            completion(route.header, false, { result, error in
                verificationCodeBlock(result, error)
                if result {
                    self.responseDelegate?.onHumanVerifyEnd(result: .success)
                }
            })
        }
        
        vm.onCloseBlock = {
            completion([:], true, nil)
            self.responseDelegate?.onHumanVerifyEnd(result: .cancel)
        }
    }
    
    public func getSupportURL() -> URL {
        return supportURL
    }
}

#endif
