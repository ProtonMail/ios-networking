//
//  VerifyCodeViewController.swift
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
import PMUIFoundations
import PMCoreTranslation

class VerifyCodeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var verifyCodeTextFieldView: PMTextField!
    @IBOutlet weak var continueButton: ProtonButton!
    @IBOutlet weak var newCodeButton: ProtonButton!
    @IBOutlet weak var backBarbuttonItem: UIBarButtonItem!
    @IBOutlet weak var scrollBottomPaddingConstraint: NSLayoutConstraint!
    
    fileprivate let kSegueToHelp = "check_menu_to_help_segue"
    fileprivate let kSegueUnwind = "UnwindSegue"
    
    var viewModel: HumanCheckViewModel!
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addKeyboardObserver(self)
        _ = verifyCodeTextFieldView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeKeyboardObserver(self)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueToHelp {
            let viewController = segue.destination as! HumanCheckHelpViewController
            viewController.viewModel = self.viewModel
        }
    }
    
    // MARK: - Actions
    
    @IBAction func verifyCodeAction(_ sender: Any) {
        sendCode()
    }
    
    @IBAction func requestReplacementAction(_ sender: Any) {
        let alert = UIAlertController(title: CoreString._hv_verification_new_alert_title, message: String(format: CoreString._hv_verification_new_alert_message, self.viewModel.getDestination()), preferredStyle: .alert)
        alert.addAction(.init(title: CoreString._hv_verification_new_alert_button, style: .default, handler: { _ in
            self.resendCode()
        }))
        alert.addAction(.init(title: CoreString._hv_cancel_button, style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        updateButtonStatus()
        dismissKeyboard()
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private interface
    
    fileprivate func configureUI() {
        backBarbuttonItem.tintColor = UIColorManager.IconNorm
        view.backgroundColor = UIColorManager.BackgroundNorm
        title = CoreString._hv_title
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: CoreString._hv_help_button, style: .done, target: self, action: #selector(helpButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColorManager.BrandNorm
        topTitleLabel.text = self.viewModel.getTitle()
        topTitleLabel.textColor = UIColorManager.TextWeak
        verifyCodeTextFieldView.title = CoreString._hv_verification_code
        verifyCodeTextFieldView.assistiveText = CoreString._hv_verification_code_hint
        verifyCodeTextFieldView.placeholder = "XXXXXX"
        verifyCodeTextFieldView.delegate = self
        verifyCodeTextFieldView.keyboardType = .numberPad
        verifyCodeTextFieldView.autocorrectionType = .no
        verifyCodeTextFieldView.autocapitalizationType = .none
        verifyCodeTextFieldView.spellCheckingType = .no
        if #available(iOS 12.0, *) {
            verifyCodeTextFieldView.textContentType = .oneTimeCode
        } else {
            verifyCodeTextFieldView.textContentType = .none
        }
        continueButton.setTitle(CoreString._hv_verification_verify_button, for: .normal)
        continueButton.setMode(mode: .solid)
        newCodeButton.setTitle(CoreString._hv_verification_not_receive_code_button, for: .normal)
        newCodeButton.setMode(mode: .text)
        self.updateButtonStatus()
    }
    
    fileprivate func sendCode() {
        let code = verifyCodeTextFieldView.value.trim()
        guard viewModel.isValidCodeFormat(code: code) else { return }
        
        continueButton.isSelected = true
        verifyCodeTextFieldView.isError = false
        continueButton.setTitle(CoreString._hv_verification_verifying_button, for: .normal)
        self.viewModel.finalToken(token: code) { (res, error) in
            DispatchQueue.main.async {
                self.verifyCodeTextFieldView.value = ""
                self.continueButton.isEnabled = true
                self.continueButton.isSelected = false
                self.continueButton.setTitle(CoreString._hv_verification_verify_button, for: .normal)
                if res {
                    self.verifyCodeTextFieldView.isError = false
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    if let error = error {
                        self.showErrorAlert(error: error)
                    }
                }
            }
        }
    }
    
    fileprivate func showErrorAlert(error: NSError) {
        if error.code == 12087 {
            // Invalid verification code
            showInvalidVerificationCodeAlert()
            self.verifyCodeTextFieldView.isError = true
        } else {
            let banner = PMBanner(message: error.localizedDescription, style: PMBannerNewStyle.error, dismissDuration: Double.infinity)
            banner.addButton(text: CoreString._hv_ok_button) { _ in
                banner.dismiss()
            }
            banner.show(at: .topCustom(.baner), on: self)
        }
    }
    
    fileprivate func showInvalidVerificationCodeAlert() {
        let title = CoreString._hv_verification_error_alert_title
        let message = CoreString._hv_verification_error_alert_message
        let leftButton = CoreString._hv_verification_error_alert_resend
        let rightButton = CoreString._hv_verification_error_alert_other_method
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: leftButton, style: .default, handler: { action in
            self.resendCode()
        }))
        alert.addAction(UIAlertAction(title: rightButton, style: .cancel, handler: { action in
            self.performSegue(withIdentifier: self.kSegueUnwind, sender: self)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func resendCode() {
        self.continueButton.isEnabled = false
        self.newCodeButton.isEnabled = false
        self.viewModel.sendVerifyCode (self.viewModel.type) { (isOK, error) -> Void in
            self.updateButtonStatus()
            self.newCodeButton.isEnabled = true
            if isOK {
                let banner = PMBanner(message: self.viewModel.getMsg(), style: PMBannerNewStyle.success)
                banner.show(at: .topCustom(.baner), on: self)
            } else {
                if let description = error?.localizedDescription {
                    let banner = PMBanner(message: description, style: PMBannerNewStyle.error, dismissDuration: Double.infinity)
                    banner.addButton(text: CoreString._hv_ok_button) { _ in
                        banner.dismiss()
                    }
                    banner.show(at: .topCustom(.baner), on: self)
                }
            }
        }
    }
    
    @objc fileprivate func helpButtonTapped(sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.kSegueToHelp, sender: self)
    }
    
    fileprivate func dismissKeyboard() {
        _ = verifyCodeTextFieldView.resignFirstResponder()
    }
    
    fileprivate func updateButtonStatus() {
        let verifyCode = verifyCodeTextFieldView.value.trim()
        if viewModel.isValidCodeFormat(code: verifyCode) {
            continueButton.isEnabled = true
        } else {
            continueButton.isEnabled = false
        }
    }
}

// MARK: - PMTextFieldDelegate

extension VerifyCodeViewController: PMTextFieldDelegate {
    func didChangeValue(_ textField: PMTextField, value: String) {
        updateButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: PMTextField) -> Bool {
        updateButtonStatus()
        dismissKeyboard()
        sendCode()
        return true
    }
    
    func didEndEditing(textField: PMTextField) {
        updateButtonStatus()
    }
}

// MARK: - NSNotificationCenterKeyboardObserverProtocol

extension VerifyCodeViewController: NSNotificationCenterKeyboardObserverProtocol {
    func keyboardWillHideNotification(_ notification: Notification) {
        let keyboardInfo = notification.keyboardInfo
        scrollBottomPaddingConstraint.constant = 0.0
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
            self.scrollBottomPaddingConstraint.constant = 0.0
        }, completion: nil)
    }

    func keyboardWillShowNotification(_ notification: Notification) {
        let keyboardInfo = notification.keyboardInfo
        let info: NSDictionary = notification.userInfo! as NSDictionary
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
            if let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.scrollBottomPaddingConstraint.constant = keyboardSize.height - UIEdgeInsets.saveAreaBottom
            }
        }, completion: nil)
    }
}

#endif
