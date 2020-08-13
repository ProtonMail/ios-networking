//
//  HumanCheckMenuViewController.swift
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

//TODO:: add coordinator and add to all sub VCs

final public class HumanCheckHelpViewController: UIViewController {
    
    fileprivate let kSegueToRecaptcha = "check_menu_to_recaptcha_verify_segue"
    fileprivate let kSegueToEmailVerify = "check_menu_to_email_verify_segue"
    fileprivate let kSegueToPhoneVerify = "check_menu_to_phone_verify_segue"
    
    @IBOutlet weak var recaptchaViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var phoneViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topNotesLabel: UILabel!
    @IBOutlet weak var optionsTitleLabel: UILabel!
    
    @IBOutlet weak var captchaButton: UIButton!
    @IBOutlet weak var emailCheckButton: UIButton!
    @IBOutlet weak var phoneCheckButton: UIButton!
    
    fileprivate let kButtonHeight : CGFloat = 60.0
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!

    //var viewModel : SignupViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    public override func viewDidLoad() {
        super.viewDidLoad()
        
//        topLeftButton.setTitle(LocalString._general_back_action, for: .normal)
//        topTitleLabel.text = LocalString._human_verification
//        topNotesLabel.text = LocalString._to_prevent_abuse_of_protonmail_we_need_to_verify_that_you_are_human
//        optionsTitleLabel.text = LocalString._please_select_one_of_the_following_options
//
//        captchaButton.setTitle(LocalString._captcha, for: .normal)
//        emailCheckButton.setTitle(LocalString._email_verification, for: .normal)
//        phoneCheckButton.setTitle(LocalString._phone_verification, for: .normal)
        
        title = "Help"
        self.setupSignUpFunctions()
    }

    internal func setupSignUpFunctions () {
//        let directs = viewModel.getDirect()
//        if directs.count <= 0 {
//            let alert = LocalString._mobile_signups_are_disabled_pls_later_pm_com.alertController()
//            alert.addOKAction()
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            for dir in directs {
//                if dir == "captcha" {
//                    recaptchaViewConstraint.constant = kButtonHeight
//                } else if dir == "email" {
//                    emailViewConstraint.constant = kButtonHeight
//                } else if dir == "sms" {
//                    phoneViewConstraint.constant = kButtonHeight
//                }
//            }
//        }
        
        
        // setup index
        
        
        // setup view
        
//        let bundle = Bundle(for: HumanCheckMenuViewController.self)
//        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: bundle)
//        guard let customViewController = storyboard.instantiateViewController(withIdentifier: "CountryPickerViewController") as? CountryPickerViewController else {
//            print("bad")
//            return
//        }
//        customViewController.willMove(toParent: nil)
//        // Remove Child View From Superview
//        customViewController.view.removeFromSuperview()
//        // Notify Child View Controller
//        customViewController.removeFromParent()
//
//        self.containerView.addSubview(customViewController.view)
//
//        customViewController.view.frame = self.view.bounds
//        customViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        // Notify Child View Controller
//        customViewController.didMove(toParent: self)
    }
    
    
    public override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default;
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == kSegueToRecaptcha {
//            let viewController = segue.destination as! RecaptchaViewController
//            viewController.viewModel = self.viewModel
//        } else if segue.identifier == kSegueToEmailVerify {
//            let viewController = segue.destination as! EmailVerifyViewController
//            viewController.viewModel = self.viewModel
//        } else if segue.identifier == kSegueToPhoneVerify {
//            let viewController = segue.destination as! PhoneVerifyViewController
//            viewController.viewModel = self.viewModel
//        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func recaptchaAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: kSegueToRecaptcha, sender: self)
    }

    @IBAction func emailVerifyAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: kSegueToEmailVerify, sender: self)
    }

    @IBAction func phoneVerifyAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: kSegueToPhoneVerify, sender: self)
    }

}



// MARK: - UITableViewDataSource
extension HumanCheckHelpViewController: UITableViewDataSource {
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.zeroMargin()
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "help_cell", for: indexPath) as! HelpTableViewCell
        if indexPath.row == 0 {
            cell.ConfigCell(top: "Manual Verification", details: "If the three option for human verifications are not working for you, you can contact us to for a manual verification.")
        } else  {
            cell.ConfigCell(top: "Help Page on our website", details: "If you need more information on the human verification. Why this is needed etc.")
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.zeroMargin()
    }
}

// MARK: - UITableViewDelegate

extension HumanCheckHelpViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
#endif
