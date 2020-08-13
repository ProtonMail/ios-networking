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
//import MBProgressHUD

class VerifyCodeViewController: UIViewController { //}, SignupViewModelDelegate {
    
    @IBOutlet weak var errorView: ComposeErrorView!
    @IBOutlet weak var verifyCodeTextField: TextInsetTextField!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var scrollBottomPaddingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var codeInputView: UIView!
    @IBOutlet weak var topTitleLabel: UILabel!
    
    fileprivate var startVerify : Bool = false
    fileprivate var checkUserStatus : Bool = false
    fileprivate var stopLoading : Bool = false
    var viewModel : HumanCheckViewModel!
    
    fileprivate var doneClicked : Bool = false
    fileprivate var timer : Timer!
    fileprivate var countryCode : String = "+1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Human verification"
        topTitleLabel.text = self.viewModel.getTitle()
        self.errorView.isHidden = false
        self.errorView.setOk(self.viewModel.getMsg())
        
        self.codeInputView.roundCorners(radius: 3.0)
        self.codeInputView.layer.borderWidth = 1
        self.codeInputView.layer.borderColor = UIColor.init(hexColorCode: "#657EE4").cgColor
        
        self.updateButtonStatus()
    }

    func shouldShowSideMenu() -> Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addKeyboardObserver(self)
//        self.viewModel.setDelegate(self)
//        //register timer
//        self.startAutoFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeKeyboardObserver(self)
//        self.viewModel.setDelegate(nil)
//        //unregister timer
//        self.stopAutoFetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func verificationCodeChanged(_ viewModel: SignupViewModel, code: String!) {
//        verifyCodeTextField.text = code
//    }
    
    fileprivate func startAutoFetch() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PhoneVerifyViewController.countDown), userInfo: nil, repeats: true)
        self.timer.fire()
    }
    
    fileprivate func stopAutoFetch() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc func countDown() {
//        let count = self.viewModel.getTimerSet()
//        UIView.performWithoutAnimation { () -> Void in
//            if count != 0 {
//                self.sendCodeButton.setTitle(String(format: LocalString._retry_after_seconds, count), for: UIControl.State())
//            } else {
//                self.sendCodeButton.setTitle(LocalString._send_verification_code, for: UIControl.State())
//            }
//            self.sendCodeButton.layoutIfNeeded()
//        }
        updateButtonStatus()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == kSegueToNotificationEmail {
//            let viewController = segue.destination as! SignUpEmailViewController
//            viewController.viewModel = self.viewModel
//        } else if segue.identifier == kSegueToCountryPicker {
//            let popup = segue.destination as! CountryPickerViewController
//            popup.delegate = self
//            self.setPresentationStyleForSelfController(self, presentingController: popup)
//        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        stopLoading = true
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func verifyCodeAction(_ sender: Any) {
        let phonenumber = (verifyCodeTextField.text ?? "").trim()
        if phonenumber.count == 6 {
            //ok
            self.viewModel.finalToken(token: phonenumber)
            // verify 6 digits only
            let _ = self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.errorView.isHidden = false
            self.errorView.setError("Incorrect code. Please try again.", withShake: true)
        }
    }
    
    @IBAction func requestReplacementAction(_ sender: Any) {
        self.errorView.isHidden = true
        let alert = UIAlertController(title: "Request new code?", message: "Get a replacement code send to \(self.viewModel.getDestination()).", preferredStyle: .alert)
        
        alert.addAction(.init(title: "Request new code", style: .default, handler: { _ in
            self.errorView.isHidden = false
            self.errorView.setOk(self.viewModel.getMsg())
        }))
        alert.addAction(.init(title: "Cancel", style: .cancel, handler: { _ in
            //
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendCodeAction(_ sender: UIButton) {
//        let buildPhonenumber = "\(countryCode)\(phonenumber)"
//        MBProgressHUD.showAdded(to: view, animated: true)
//        viewModel.setCodePhone(buildPhonenumber)
//        self.viewModel.sendVerifyCode (.sms) { (isOK, error) -> Void in
//            MBProgressHUD.hide(for: self.view, animated: true)
//            if !isOK {
//                var alert :  UIAlertController!
//                var title = LocalString._verification_code_request_failed
//                var message = ""
//                if error?.code == 12231 {
//                    title = LocalString._phone_number_invalid
//                    message = LocalString._please_input_a_valid_cell_phone_number
//                } else {
//                    message = error!.localizedDescription
//                }
//                alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                alert.addOKAction()
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                let alert = UIAlertController(title: LocalString._verification_code_sent,
//                                              message: LocalString._please_check_your_cell_phone_for_the_verification_code,
//                                              preferredStyle: .alert)
//                alert.addOKAction()
//                self.present(alert, animated: true, completion: nil)
//            }
//            PMLog.D("\(isOK),   \(String(describing: error))")
//        }
    }
    
//    @IBAction func verifyCodeAction(_ sender: UIButton) {
////        dismissKeyboard()
////
////        if doneClicked {
////            return
////        }
////        doneClicked = true;
////        MBProgressHUD.showAdded(to: view, animated: true)
////        dismissKeyboard()
////        viewModel.setPhoneVerifyCode(verifyCodeTextField.text!)
////        DispatchQueue.main.async(execute: { () -> Void in
////            self.viewModel.createNewUser { (isOK, createDone, message, error) -> Void in
////                MBProgressHUD.hide(for: self.view, animated: true)
////                self.doneClicked = false
////                if !message.isEmpty {
////                    let title = LocalString._create_user_failed
////                    var message = LocalString._default_error_please_try_again
////                    if let error = error {
////                        message = error.localizedDescription
////                    }
////                    let alert = UIAlertController(title: title, message: message, 	preferredStyle: .alert)
////                    alert.addOKAction()
////                    self.present(alert, animated: true, completion: nil)
////                } else {
////                    if isOK || createDone {
////                        DispatchQueue.main.async(execute: { () -> Void in
////                            self.performSegue(withIdentifier: self.kSegueToNotificationEmail, sender: self)
////                        })
////                    }
////                }
////            }
////        })
//    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        updateButtonStatus()
        dismissKeyboard()
    }
    func dismissKeyboard() {
        verifyCodeTextField.resignFirstResponder()
    }
    
    @IBAction func editEnd(_ sender: UITextField) {

    }
    
    @IBAction func editingChanged(_ sender: AnyObject) {
        updateButtonStatus();
    }
    
    func updateButtonStatus() {
        let verifyCode = (verifyCodeTextField.text ?? "").trim()
        if verifyCode.isEmpty {
            continueButton.isEnabled = false
        } else {
            continueButton.isEnabled = true
        }
    }
}

// MARK: - UITextFieldDelegatesf
extension VerifyCodeViewController : UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        self.errorView.isHidden = true
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateButtonStatus()
        dismissKeyboard()
        //
        return true
    }
}


//// MARK: - NSNotificationCenterKeyboardObserverProtocol
extension VerifyCodeViewController : NSNotificationCenterKeyboardObserverProtocol {
    func keyboardWillHideNotification(_ notification: Notification) {
        let keyboardInfo = notification.keyboardInfo
        scrollBottomPaddingConstraint.constant = 0.0
        //self.configConstraint(false)
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    func keyboardWillShowNotification(_ notification: Notification) {
        let keyboardInfo = notification.keyboardInfo
        let info: NSDictionary = notification.userInfo! as NSDictionary
        if let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollBottomPaddingConstraint.constant = keyboardSize.height;
        }
        //self.configConstraint(true)
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
#endif
