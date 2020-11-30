//
//  EmailVerifyViewController.swift
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

class EmailVerifyViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var emailTextFieldView: PMTextField!
    @IBOutlet weak var sendCodeButton: ProtonButton!
    @IBOutlet weak var continueButton: ProtonButton!
    @IBOutlet weak var scrollBottomPaddingConstraint: NSLayoutConstraint!
    
    fileprivate let kSegueToVerifyCode = "email_verify_to_verify_code_segue"
    fileprivate var verifyClicked = false
    
    var viewModel: HumanCheckViewModel!
    
    // MARK: View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addKeyboardObserver(self)
        _ = emailTextFieldView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeKeyboardObserver(self)
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.kSegueToVerifyCode {
            let viewController = segue.destination as! VerifyCodeViewController
            self.viewModel.type = .email
            viewController.viewModel = self.viewModel            
        }
    }
    
    // MARK: Actions
    
    @IBAction func haveCodeAction(_ sender: Any) {
        guard let emailaddress = validateEmailAddress else { return }
        dismissKeyboard()
        self.viewModel.setEmail(email: emailaddress)
        self.performSegue(withIdentifier: self.kSegueToVerifyCode, sender: self)
    }
    
    @IBAction func sendCodeAction(_ sender: UIButton) {
        self.sendEmail()
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        updateButtonStatus()
        dismissKeyboard()
    }
    
    // MARK: Private interface
    
    fileprivate func configureUI() {
        view.backgroundColor = UIColorManager.BackgroundNorm
        topTitleLabel.text = CoreString._hv_email_enter_label
        topTitleLabel.textColor = UIColorManager.TextWeak
        emailTextFieldView.title = CoreString._hv_email_label
        emailTextFieldView.placeholder = "example@protonmail.com"
        emailTextFieldView.delegate = self
        emailTextFieldView.keyboardType = .emailAddress
        emailTextFieldView.textContentType = .emailAddress
        emailTextFieldView.autocorrectionType = .no
        emailTextFieldView.autocapitalizationType = .none
        emailTextFieldView.spellCheckingType = .no
        sendCodeButton.setMode(mode: .solid)
        sendCodeButton.setTitle(CoreString._hv_email_verification_button, for: .normal)
        continueButton.setMode(mode: .text)
        continueButton.setTitle(CoreString._hv_email_have_code_button, for: .normal)
        updateButtonStatus()
    }
    
    fileprivate func sendEmail() {
        guard !verifyClicked else { return }
        guard let email = validateEmailAddress else { return }
        verifyClicked = true
        dismissKeyboard()
        self.viewModel.setEmail(email: email)
        sendCodeButton.isSelected = true
        continueButton.isEnabled = false
        self.viewModel.sendVerifyCode (.email) { (isOK, error) -> Void in
            self.verifyClicked = false
            self.continueButton.isEnabled = true
            self.sendCodeButton.isSelected = false
            if isOK {
                self.performSegue(withIdentifier: self.kSegueToVerifyCode, sender: self)
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
    
    fileprivate func dismissKeyboard() {
        _ = emailTextFieldView.resignFirstResponder()
    }
    
    fileprivate func updateButtonStatus() {
        if let _ = validateEmailAddress {
            sendCodeButton.isEnabled = true
            continueButton.isEnabled = true
        } else {
            sendCodeButton.isEnabled = false
            continueButton.isEnabled = false
        }
    }
    
    fileprivate var validateEmailAddress: String? {
        let emailaddress = emailTextFieldView.value
        guard emailaddress != "", viewModel.isValidEmail(email: emailaddress) else { return nil }
        return emailaddress
    }
}

// MARK: - PMTextFieldDelegate

extension EmailVerifyViewController: PMTextFieldDelegate {
    func didChangeValue(_ textField: PMTextField, value: String) {
        updateButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: PMTextField) -> Bool {
        updateButtonStatus()
        dismissKeyboard()
        sendEmail()
        return true
    }
    
    func didEndEditing(textField: PMTextField) {
        updateButtonStatus()
    }
}

// MARK: - NSNotificationCenterKeyboardObserverProtocol

extension EmailVerifyViewController: NSNotificationCenterKeyboardObserverProtocol {
    func keyboardWillHideNotification(_ notification: Notification) {
        let keyboardInfo = notification.keyboardInfo
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
