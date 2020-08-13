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
class HumanCheckHelper: HumanVerifyDelegate {
    func onHumanVerify(methods : [VerifyMethod]) {
        
    }
    
    
    
    
    
}



//func onHumanVerify() {

//}
//
//
//class EmailVerifyViewController: UIViewController { //}, SignupViewModelDelegate {
//    
//    @IBOutlet weak var emailTextField: TextInsetTextField!
//    @IBOutlet weak var sendCodeButton: UIButton!
//    @IBOutlet weak var continueButton: UIButton!
//    
//    @IBOutlet weak var topTitleLabel: UILabel!
//    @IBOutlet weak var scrollBottomPaddingConstraint: NSLayoutConstraint!
//    
//    private let kSegueToNotificationEmail = "sign_up_pwd_email_segue"
//    private let kSegueToVerifyCode = "email_verify_to_verify_code_segue"
//    
//    fileprivate var startVerify : Bool = false
//    fileprivate var checkUserStatus : Bool = false
//    fileprivate var stopLoading : Bool = false
//    fileprivate var doneClicked : Bool = false
//    
//    fileprivate var timer : Timer!
//    @IBOutlet weak var inputEmailView: UIView!
//    @IBOutlet weak var errorView: ComposeErrorView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.inputEmailView.roundCorners()
//        self.inputEmailView.layer.borderWidth = 1
//        self.inputEmailView.layer.borderColor = UIColor.blue.cgColor
//        self.title = "Human verification"
//
//        //  self.updateButtonStatus()
//    }
//    
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return UIStatusBarStyle.default;
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
////        NotificationCenter.default.addKeyboardObserver(self)
////        self.viewModel.setDelegate(self)
////        //register timer
////        self.startAutoFetch()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        NotificationCenter.default.removeKeyboardObserver(self)
////        self.viewModel.setDelegate(nil)
////        //unregister timer
////        self.stopAutoFetch()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    fileprivate func startAutoFetch() {
//        self.timer = Timer.scheduledTimer(timeInterval: 1,
//                                          target: self,
//                                          selector: #selector(EmailVerifyViewController.countDown),
//                                          userInfo: nil,
//                                          repeats: true)
//        self.timer.fire()
//    }
//    fileprivate func stopAutoFetch()
//    {
//        if self.timer != nil {
//            self.timer.invalidate()
//            self.timer = nil
//        }
//    }
//    
//    @objc func countDown() {
////        let count = self.viewModel.getTimerSet()
////        UIView.performWithoutAnimation { () -> Void in
////            if count != 0 {
////                self.sendCodeButton.setTitle(String(format: LocalString._retry_after_seconds, count), for: UIControl.State())
////            } else {
////                self.sendCodeButton.setTitle(LocalString._send_verification_code, for: UIControl.State())
////            }
////            self.sendCodeButton.layoutIfNeeded()
////        }
//        updateButtonStatus()
//    }
//    
//    // MARK: - Navigation
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == kSegueToNotificationEmail {
////            let viewController = segue.destination as! SignUpEmailViewController
////            viewController.viewModel = self.viewModel
//        }
//    }
//    
//    @IBAction func backAction(_ sender: UIButton) {
//        stopLoading = true
//        let _ = self.navigationController?.popViewController(animated: true)
//    }
//    @IBAction func haveCodeAction(_ sender: Any) {
//        self.performSegue(withIdentifier: self.kSegueToVerifyCode, sender: self)
//    }
//    
//    @IBAction func sendCodeAction(_ sender: UIButton) {
//        let emailaddress = emailTextField.text
//        self.errorView.isHidden = false
//        self.errorView.setError("This is error message", withShake: true)
//        
//       // MBProgressHUD.showAdded(to: view, animated: true)
////        viewModel.setCodeEmail(emailaddress!)
// //       self.viewModel.sendVerifyCode (.email) { (isOK, error) -> Void in
////            MBProgressHUD.hide(for: self.view, animated: true)
////            if !isOK {
////                var alert :  UIAlertController!
////                var title = LocalString._verification_code_request_failed
////                var message = ""
////                if error?.code == 12201 { //USER_CODE_EMAIL_INVALID = 12201
////                    title = LocalString._email_address_invalid
////                    message = LocalString._please_input_a_valid_email_address
////                } else {
////                    message = error!.localizedDescription
////                }
////                alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
////                alert.addOKAction()
////                self.present(alert, animated: true, completion: nil)
////            } else {
////                let alert = UIAlertController(title: LocalString._verification_code_sent,
////                                              message: LocalString._please_check_email_for_code,
////                                              preferredStyle: .alert)
////                alert.addOKAction()
////                self.present(alert, animated: true, completion: nil)
////            }
////            PMLog.D("\(isOK),   \(String(describing: error))")
// //       }
//        
//        // self.performSegue(withIdentifier: self.kSegueToVerifyCode, sender: self)
//    }
//    
//    @IBAction func verifyCodeAction(_ sender: UIButton) {
//        dismissKeyboard()
//        
//        if doneClicked {
//            return
//        }
//        doneClicked = true;
//    //    MBProgressHUD.showAdded(to: view, animated: true)
//        dismissKeyboard()
// //       viewModel.setEmailVerifyCode(verifyCodeTextField.text!)
////        DispatchQueue.main.async(execute: { () -> Void in
////            self.viewModel.createNewUser { (isOK, createDone, message, error) -> Void in
//////                DispatchQueue.main.async(execute: { () -> Void in
//////                    MBProgressHUD.hide(for: self.view, animated: true)
//////                    self.doneClicked = false
//////                    if !message.isEmpty {
//////                        let title = LocalString._create_user_failed
//////                        var message = LocalString._default_error_please_try_again
//////                        if let error = error {
//////                            message = error.localizedDescription
//////                        }
//////                        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//////                        alert.addOKAction()
//////                        self.present(alert, animated: true, completion: nil)
//////                    } else {
//////                        if isOK || createDone {
//////                            self.performSegue(withIdentifier: self.kSegueToNotificationEmail, sender: self)
//////                        }
//////                    }
//////                })
////            }
////        })
//    }
//    
//    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
//        updateButtonStatus()
//        dismissKeyboard()
//    }
//    func dismissKeyboard() {
//        emailTextField.resignFirstResponder()
// //       verifyCodeTextField.resignFirstResponder()
//    }
//    
//    @IBAction func editEnd(_ sender: UITextField) {
//
//    }
//    
//    @IBAction func editingChanged(_ sender: AnyObject) {
//        updateButtonStatus();
//    }
//    
//    func updateButtonStatus() {
//        let emailaddress = (emailTextField.text ?? "").trim()
//        //need add timer
//        if emailaddress.isEmpty {
//            sendCodeButton.isEnabled = false
//        } else {
//            sendCodeButton.isEnabled = true
//        }
//    }
//}
//
//// MARK: - UITextFieldDelegatesf
//extension EmailVerifyViewController: UITextFieldDelegate {
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        return true
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        if textField == self.verifyCodeTextField,
////            string.hasPrefix("protonmail://signup?verifyCode=")
////        {
////            let onlyCode = string.replacingOccurrences(of: "protonmail://signup?verifyCode=", with: "")
////            textField.text = onlyCode
////            return false
////        }
//        return true
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        updateButtonStatus()
//        dismissKeyboard()
//        return true
//    }
//}
//
//// MARK: - NSNotificationCenterKeyboardObserverProtocol
//extension EmailVerifyViewController: NSNotificationCenterKeyboardObserverProtocol {
//    func keyboardWillHideNotification(_ notification: Notification) {
//        let keyboardInfo = notification.keyboardInfo
//        scrollBottomPaddingConstraint.constant = 0.0
//        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//    
//    func keyboardWillShowNotification(_ notification: Notification) {
//        let keyboardInfo = notification.keyboardInfo
//        let info: NSDictionary = notification.userInfo! as NSDictionary
//        if let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            scrollBottomPaddingConstraint.constant = keyboardSize.height;
//        }
//        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//}
#endif
