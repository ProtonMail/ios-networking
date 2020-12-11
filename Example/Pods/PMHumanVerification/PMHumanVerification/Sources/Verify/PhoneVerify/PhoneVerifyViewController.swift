//
//  PhoneVerifyViewController.swift
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

class PhoneVerifyViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var phoneNumberTextFieldView: PMTextFieldCombo!
    @IBOutlet weak var sendCodeButton: ProtonButton!
    @IBOutlet weak var continueButton: ProtonButton!
    @IBOutlet weak var scrollBottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTitleLabel: UILabel!

    fileprivate let kSegueToCountryPicker = "phone_verify_to_country_picker_segue"
    fileprivate let kSegueToVerifyCode = "phone_verify_to_verify_code_segue"

    fileprivate var verifyClicked = false
    fileprivate var countryCode: String = ""

    var viewModel: HumanCheckViewModel!
    var countryCodeViewModel: CountryCodeViewModel!

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
        _ = phoneNumberTextFieldView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeKeyboardObserver(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.kSegueToVerifyCode {
            let viewController = segue.destination as! VerifyCodeViewController
            self.viewModel.type = .sms
            viewController.viewModel = self.viewModel
        } else if segue.identifier == kSegueToCountryPicker {
            let popup = segue.destination as! CountryPickerViewController
            popup.viewModel = countryCodeViewModel
            popup.delegate = self
        }
    }

    @IBAction func haveCodeAction(_ sender: Any) {
        guard phoneNumberTextFieldView.value != "" else { return }
        let buildPhonenumber = "\(countryCode)\(phoneNumberTextFieldView.value)"
        self.viewModel.setEmail(email: buildPhonenumber)
        self.performSegue(withIdentifier: self.kSegueToVerifyCode, sender: self)
    }

    @IBAction func sendCodeAction(_ sender: UIButton) {
        self.sendCode()
    }

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        updateButtonStatus()
        dismissKeyboard()
    }

    // MARK: Private interface

    fileprivate func dismissKeyboard() {
        _ = phoneNumberTextFieldView.resignFirstResponder()
    }

    fileprivate func configureUI() {
        view.backgroundColor = UIColorManager.BackgroundNorm
        topTitleLabel.text = CoreString._hv_sms_enter_label
        topTitleLabel.textColor = UIColorManager.TextWeak
        sendCodeButton.setTitle(CoreString._hv_email_verification_button, for: UIControl.State())
        continueButton.setTitle(CoreString._hv_email_have_code_button, for: UIControl.State())
        countryCodeViewModel = CountryCodeViewModel()
        updateCountryCode(countryCodeViewModel.getPhoneCodeFromName(NSLocale.current.regionCode))
        phoneNumberTextFieldView.title = CoreString._hv_sms_label
        phoneNumberTextFieldView.placeholder = "XX XXX XX XX"
        phoneNumberTextFieldView.delegate = self
        phoneNumberTextFieldView.keyboardType = .phonePad
        phoneNumberTextFieldView.textContentType = .telephoneNumber
        phoneNumberTextFieldView.autocorrectionType = .no
        phoneNumberTextFieldView.autocapitalizationType = .none
        phoneNumberTextFieldView.spellCheckingType = .no
        sendCodeButton.setMode(mode: .solid)
        continueButton.setMode(mode: .text)
        updateButtonStatus()
    }

    fileprivate func updateCountryCode(_ code: Int) {
        countryCode = "+\(code)"
        phoneNumberTextFieldView.buttonTitleText = countryCode
    }

    fileprivate func updateButtonStatus() {
        let phoneNumber = phoneNumberTextFieldView.value.trim()
        sendCodeButton.isSelected = false
        if phoneNumber.isEmpty {
            sendCodeButton.isEnabled = false
            continueButton.isEnabled = false
        } else {
            sendCodeButton.isEnabled = true
            continueButton.isEnabled = true
        }
    }

    fileprivate func sendCode() {
        guard !verifyClicked else { return }
        verifyClicked = true
        dismissKeyboard()

        let buildPhonenumber = "\(countryCode)\(phoneNumberTextFieldView.value)"
        self.viewModel.setEmail(email: buildPhonenumber)
        sendCodeButton.isSelected = true
        continueButton.isEnabled = false
        self.viewModel.sendVerifyCode(.sms) { (isOK, error) -> Void in
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
}

extension PhoneVerifyViewController: CountryPickerViewControllerDelegate {

    func dismissed() {

    }

    func apply(_ country: CountryCode) {
        self.updateCountryCode(country.phone_code)
    }
}

// MARK: - PMTextFieldComboDelegate

extension PhoneVerifyViewController: PMTextFieldComboDelegate {
    func didChangeValue(_ textField: PMTextFieldCombo, value: String) {
        updateButtonStatus()
    }

    func didEndEditing(textField: PMTextFieldCombo) {
        updateButtonStatus()
    }

    func textFieldShouldReturn(_ textField: PMTextFieldCombo) -> Bool {
        updateButtonStatus()
        dismissKeyboard()
        sendCode()
        return true
    }

    func userDidRequestDataSelection(button: UIButton) {
        self.performSegue(withIdentifier: kSegueToCountryPicker, sender: self)
    }
}

// MARK: - NSNotificationCenterKeyboardObserverProtocol

extension PhoneVerifyViewController: NSNotificationCenterKeyboardObserverProtocol {
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
