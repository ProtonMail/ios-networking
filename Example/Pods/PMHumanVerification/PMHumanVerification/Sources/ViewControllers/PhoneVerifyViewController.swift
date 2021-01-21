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
import PMCommon
import PMCoreTranslation

protocol PhoneVerifyViewControllerDelegate: class {
    func didVerifyPhoneCode(method: VerifyMethod, destination: String)
    func didSelectCountryPicker()
}

class PhoneVerifyViewController: BaseUIViewController {

    // MARK: Outlets

    @IBOutlet weak var phoneNumberTextFieldView: PMTextFieldCombo!
    @IBOutlet weak var sendCodeButton: ProtonButton!
    @IBOutlet weak var scrollBottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTitleLabel: UILabel!

    private var countryCode: String = ""

    weak var delegate: PhoneVerifyViewControllerDelegate?
    var viewModel: VerifyViewModel!
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
        _ = phoneNumberTextFieldView.becomeFirstResponder()
    }

    override var bottomPaddingConstraint: CGFloat {
        didSet {
            scrollBottomPaddingConstraint.constant = bottomPaddingConstraint
        }
    }

    @IBAction func sendCodeAction(_ sender: UIButton) {
        sendCode()
    }

    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        updateButtonStatus()
        dismissKeyboard()
    }

    func updateCountryCode(_ code: Int) {
        countryCode = "+\(code)"
        phoneNumberTextFieldView.buttonTitleText = countryCode
    }

    // MARK: Private interface

    private func dismissKeyboard() {
        _ = phoneNumberTextFieldView.resignFirstResponder()
    }

    private func configureUI() {
        view.backgroundColor = UIColorManager.BackgroundNorm
        topTitleLabel.text = CoreString._hv_sms_enter_label
        topTitleLabel.textColor = UIColorManager.TextWeak
        sendCodeButton.setTitle(CoreString._hv_email_verification_button, for: UIControl.State())
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
        updateButtonStatus()
    }

    private func updateButtonStatus() {
        let phoneNumber = phoneNumberTextFieldView.value.trim()
        if phoneNumber.isEmpty {
            sendCodeButton.isEnabled = false
        } else {
            sendCodeButton.isEnabled = true
        }
    }

    private func sendCode() {
        dismissKeyboard()
        let buildPhonenumber = "\(countryCode)\(phoneNumberTextFieldView.value)"
        sendCodeButton.isSelected = true
        viewModel.sendVerifyCode(method: .sms, destination: buildPhonenumber) { (isOK, error) -> Void in
            self.sendCodeButton.isSelected = false
            if isOK {
                self.delegate?.didVerifyPhoneCode(method: .sms, destination: buildPhonenumber)
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
        delegate?.didSelectCountryPicker()
    }
}

#endif
