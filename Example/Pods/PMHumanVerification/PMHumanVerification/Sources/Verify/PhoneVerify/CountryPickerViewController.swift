//
//  CountryPickerViewController.swift
//  ProtonMail - Created on 3/29/16.
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

protocol CountryPickerViewControllerDelegate {
    func dismissed()
    func apply(_ country : CountryCode)
}

class CountryPickerViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    
    fileprivate let contryCodeCell = "country_code_table_cell"
    fileprivate let countryCodeHeader = "CountryCodeTableHeaderView"
    var delegate : CountryPickerViewControllerDelegate?
    var viewModel: CountryCodeViewModel! { didSet { viewModel.searchText() } }
    
    // MARK: View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addKeyboardObserver(self)
        configureUI()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeKeyboardObserver(self)
    }
    
    // MARK: Actions
    
    @IBAction func cancelAction(_ sender: UIButton) {
        delegate?.dismissed()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    // MARK: Private interface
    
    fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func configureUI() {
        cancelButton.tintColor = UIColorManager.IconNorm
        contentView.layer.cornerRadius = 4
        searchBar.placeholder = CoreString._hv_sms_search_placeholder
        searchBar.delegate = self
        contentView.backgroundColor = UIColorManager.BackgroundNorm
        tableView.backgroundColor = UIColorManager.BackgroundNorm
        
        let nib = UINib(nibName: countryCodeHeader, bundle: Common.bundle)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: countryCodeHeader)
    }

}

// MARK: - UITableViewDataSource

extension CountryPickerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCountryCodes(section: section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countryCell = tableView.dequeueReusableCell(withIdentifier: self.contryCodeCell,
                                                        for: indexPath) as! CountryCodeTableViewCell
        if let country = viewModel.getCountryCode(indexPath: indexPath) {
            countryCell.ConfigCell(country)
        }
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: countryCodeHeader)
        if let header = cell as? CountryCodeTableHeaderView {
            header.titleLabel.text = viewModel.sectionNames[section]
        }
        return cell
    }

}

// MARK: - UITableViewDelegate

extension CountryPickerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let country = viewModel.getCountryCode(indexPath: indexPath) {
            delegate?.apply(country)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CountryPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText(searchText: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }
}

// MARK: - NSNotificationCenterKeyboardObserverProtocol

extension CountryPickerViewController: NSNotificationCenterKeyboardObserverProtocol {
    func keyboardWillHideNotification(_ notification: Notification) {
        let keyboardInfo = notification.keyboardInfo
        self.tableBottomConstraint.constant = 0.0
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
        }, completion: nil)
    }
    
    func keyboardWillShowNotification(_ notification: Notification) {
        let keyboardInfo = notification.keyboardInfo
        let info: NSDictionary = notification.userInfo! as NSDictionary
        UIView.animate(withDuration: keyboardInfo.duration, delay: 0, options: keyboardInfo.animationOption, animations: { () -> Void in
            if let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.tableBottomConstraint.constant = keyboardSize.height - UIEdgeInsets.saveAreaBottom
            }
        }, completion: nil)
    }
}

#endif
