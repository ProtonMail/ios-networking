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
    
    fileprivate let kButtonHeight : CGFloat = 60.0
    
    //var viewModel : SignupViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Help"
           
        self.tableView.noSeparatorsBelowFooter()
        
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
    @IBAction func backAction(_ sender: UIButton) {
        let _ = self.navigationController?.popViewController(animated: true)
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
        cell.selectionStyle = .default
        if indexPath.row == 0 {
            let image = UIImage(named: "ic-check-circle", in: Bundle(for: type(of: self)), compatibleWith: nil)!
            cell.ConfigCell(top: "Manual Verification",
                            details: "If the three option for human verifications are not working for you, you can contact us to for a manual verification.",
                            left: image)
        } else  {
            let image = UIImage(named: "ic-lightbulp", in: Bundle(for: type(of: self)), compatibleWith: nil)!
            cell.ConfigCell(top: "Help Page on our website",
                            details: "If you need more information on the human verification. Why this is needed etc.",
                            left: image)
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
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
}
#endif
