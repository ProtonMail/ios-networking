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
    fileprivate let rootViewController: UIViewController?
    fileprivate weak var responseDelegate: HumanVerifyResponseDelegate?
    fileprivate let apiService: APIService
    fileprivate let supportURL: URL
    internal var viewModel: HumanCheckViewModelImpl?

    public init(apiService: APIService, supportURL: URL, viewController: UIViewController? = nil, responseDelegate: HumanVerifyResponseDelegate? = nil) {
        self.apiService = apiService
        self.supportURL = supportURL
        self.rootViewController = viewController
        self.responseDelegate = responseDelegate
    }

    public func onHumanVerify(methods: [VerifyMethod], startToken: String?, completion: (@escaping (HumanVerifyHeader, HumanVerifyIsClosed, SendVerificationCodeBlock?) -> Void)) {
        viewModel = HumanCheckViewModelImpl(types: methods, startToken: startToken, api: apiService)
        guard let viewModel = viewModel else { return }
        let coordinator = HumanCheckMenuCoordinator(rootViewController: rootViewController, viewModel: viewModel,
                                                    services: ServiceFactory.default)
        coordinator?.start()
        self.responseDelegate?.onHumanVerifyStart()

        viewModel.onVerificationCodeBlock = { verificationCodeBlock in
            let tokenType = viewModel.getToken()
            let client = TestApiClient(api: self.apiService)
            let route = client.triggerHumanVerifyRoute(destination: tokenType.destination, type: tokenType.verifyMethod, token: tokenType.token)
            completion(route.header, false, { result, error in
                verificationCodeBlock(result, error)
                if result {
                    self.responseDelegate?.onHumanVerifyEnd(result: .success)
                }
            })
        }

        viewModel.onCloseBlock = {
            completion([:], true, nil)
            self.responseDelegate?.onHumanVerifyEnd(result: .cancel)
        }
    }

    public func getSupportURL() -> URL {
        return supportURL
    }
}

#endif
