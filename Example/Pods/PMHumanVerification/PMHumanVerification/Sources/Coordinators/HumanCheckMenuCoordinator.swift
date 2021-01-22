//
//  HumanCheckMenuCoordinator.swift
//  ProtonMail - Created on 8/20/19.
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

protocol HumanCheckMenuCoordinatorDelegate: class {
    func verificationCode(tokenType: TokenType, verificationCodeBlock: (@escaping SendVerificationCodeBlock))
    func close()
}

class HumanCheckMenuCoordinator {

    // MARK: - Private properties

    private let apiService: APIService
    private let startToken: String?
    private var method: VerifyMethod = .captcha
    private var destination: String = ""

    /// View controllers
    private let rootViewController: UIViewController?
    private var viewController: MenuViewController?
    private var phoneVerifyViewController: PhoneVerifyViewController?

    /// View models
    private let recaptchaViewModel: RecaptchaViewModel
    private let verifyViewModel: VerifyViewModel
    private var countryCodeViewModel: CountryCodeViewModel?
    let verifyCheckViewModel: VerifyCheckViewModel

    // MARK: - Public properties

    weak var delegate: HumanCheckMenuCoordinatorDelegate?

    // MARK: - Public methods

    init?(rootViewController: UIViewController?, apiService: APIService, methods: [VerifyMethod], startToken: String?) {
        self.rootViewController = rootViewController
        self.apiService = apiService
        self.startToken = startToken

        self.recaptchaViewModel = RecaptchaViewModel(api: self.apiService, startToken: self.startToken)
        self.verifyViewModel = VerifyViewModel(api: self.apiService)
        self.verifyCheckViewModel = VerifyCheckViewModel(api: apiService, startToken: startToken)
        self.recaptchaViewModel.onVerificationCodeBlock = { verificationCodeBlock in
            self.delegate?.verificationCode(tokenType: self.recaptchaViewModel.getToken(), verificationCodeBlock: verificationCodeBlock)
        }
        self.verifyCheckViewModel.onVerificationCodeBlock = { verificationCodeBlock in
            self.delegate?.verificationCode(tokenType: self.verifyCheckViewModel.getToken(), verificationCodeBlock: verificationCodeBlock)
        }

        if NSClassFromString("XCTest") == nil {
            self.viewController = instatntiateVC(method: MenuViewController.self, identifier: "HumanCheckMenuViewController")
            self.viewController?.delegate = self
            self.viewController?.viewModel = MenuViewModel(methods: methods)
        }
    }

    func start() {
        showHumanVerification()
    }

    // MARK: - Private methods

    private func showHumanVerification() {
        guard let viewController = viewController else { return }
        if let rootViewController = rootViewController {
            let nav = UINavigationController()
            nav.modalPresentationStyle = .fullScreen
            nav.viewControllers = [viewController]
            rootViewController.present(nav, animated: true)
        } else {
            var topViewController: UIViewController?
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            if var top = keyWindow?.rootViewController {
                while let presentedViewController = top.presentedViewController {
                    top = presentedViewController
                }
                topViewController = top
            }
            let nav = UINavigationController()
            nav.modalPresentationStyle = .fullScreen
            nav.viewControllers = [viewController]
            topViewController?.present(nav, animated: true)
        }
    }

    private func showHelp() {
        let helpViewController = instatntiateVC(method: HelpViewController.self, identifier: "HumanCheckHelpViewController")
        helpViewController.delegate = self
        helpViewController.viewModel = HelpViewModel(url: apiService.humanDelegate?.getSupportURL())
        viewController?.navigationController?.pushViewController(helpViewController, animated: true)
    }

    private func showVerify() {
        let verifyViewController = instatntiateVC(method: VerifyCodeViewController.self, identifier: "VerifyCodeViewController")
        verifyViewController.delegate = self
        verifyViewController.viewModel = verifyCheckViewModel
        verifyViewController.verifyViewModel = verifyViewModel
        // update destination and method in verifyCheckViewModel
        verifyCheckViewModel.destination = destination
        verifyCheckViewModel.method = method
        viewController?.navigationController?.pushViewController(verifyViewController, animated: true)
    }
}

extension HumanCheckMenuCoordinator {
    private func instatntiateVC <T: UIViewController>(method: T.Type, identifier: String) -> T {
        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: Common.bundle)
        let customViewController = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return customViewController
    }
}

// MARK: - MenuViewControllerDelegate

extension HumanCheckMenuCoordinator: MenuViewControllerDelegate {
    func didSelectVerifyMethod(method: VerifyMethod) {
        switch method {
        case .captcha:
            let customViewController = instatntiateVC(method: RecaptchaViewController.self, identifier: "RecaptchaViewController")
            customViewController.viewModel = recaptchaViewModel
            viewController?.capchaViewController = customViewController
        case .email:
            let customViewController = instatntiateVC(method: EmailVerifyViewController.self, identifier: "EmailVerifyViewController")
            customViewController.viewModel = verifyViewModel
            customViewController.delegate = self
            viewController?.emailViewController = customViewController
        case .sms:
            phoneVerifyViewController = instatntiateVC(method: PhoneVerifyViewController.self, identifier: "PhoneVerifyViewController")
            phoneVerifyViewController?.viewModel = verifyViewModel
            phoneVerifyViewController?.delegate = self
            countryCodeViewModel = CountryCodeViewModel()
            phoneVerifyViewController?.countryCodeViewModel = countryCodeViewModel
            viewController?.smsViewController = phoneVerifyViewController
        default: break
        }
    }

    func didShowMenuHelpViewController() {
        showHelp()
    }

    func didDismissMenuViewController() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
        delegate?.close()
    }
}

// MARK: - HelpViewControllerDelegate

extension HumanCheckMenuCoordinator: HelpViewControllerDelegate {
    func didDismissHelpViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

// MARK: - EmailVerifyViewControllerDelegate

extension HumanCheckMenuCoordinator: EmailVerifyViewControllerDelegate {
    func didVerifyEmailCode(method: VerifyMethod, destination: String) {
        self.method = method
        self.destination = destination
        showVerify()
    }
}

// MARK: - PhoneVerifyViewControllerDelegate

extension HumanCheckMenuCoordinator: PhoneVerifyViewControllerDelegate {
    func didVerifyPhoneCode(method: VerifyMethod, destination: String) {
        self.method = method
        self.destination = destination
        showVerify()
    }

    func didSelectCountryPicker() {
        let countryPickerViewController = instatntiateVC(method: CountryPickerViewController.self, identifier: "CountryPickerViewController")
        countryPickerViewController.delegate = self
        countryPickerViewController.viewModel = countryCodeViewModel
        viewController?.present(countryPickerViewController, animated: true)
    }
}

// MARK: - CountryPickerViewControllerDelegate

extension HumanCheckMenuCoordinator: CountryPickerViewControllerDelegate {
    func didCountryPickerClose() {
        viewController?.dismiss(animated: true)
    }

    func didSelectCountryCode(countryCode: CountryCode) {
        phoneVerifyViewController?.updateCountryCode(countryCode.phone_code)
    }
}

// MARK: - VerifyCodeViewControllerDelegate

extension HumanCheckMenuCoordinator: VerifyCodeViewControllerDelegate {
    func didPressAnotherVerifyMethod() {
        viewController?.navigationController?.popViewController(animated: true)
        viewController?.resetUI()
    }

    func didShowVerifyHelpViewController() {
        showHelp()
    }
}

#endif
