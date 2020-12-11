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
import PMUIFoundations
import PMCoreTranslation

final public class HumanCheckHelpViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!

    var viewModel: HumanCheckViewModel!

    // MARK: - View controller life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.zeroMargin()
    }

    // MARK: - Actions

    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Private Interface

    fileprivate func configureUI() {
        closeBarButtonItem.tintColor = UIColorManager.IconNorm
        view.backgroundColor = UIColorManager.BackgroundNorm
        tableView.backgroundColor = UIColorManager.BackgroundNorm
        title = CoreString._hv_help_button
        tableView.noSeparatorsBelowFooter()
        headerLabel.textColor = UIColorManager.TextWeak
        headerLabel.text = CoreString._hv_help_header
    }

}

// MARK: - UITableViewDataSource

extension HumanCheckHelpViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "help_cell", for: indexPath) as! HelpTableViewCell
        cell.selectionStyle = .default
        if indexPath.row == 0 {
            let image = UIImage(named: "ic-check-circle", in: Common.bundle, compatibleWith: nil)!
            cell.configCell(top: CoreString._hv_help_request_item_title,
                            details: CoreString._hv_help_request_item_message,
                            left: image)
        } else {
            let image = UIImage(named: "ic-lightbulp", in: Common.bundle, compatibleWith: nil)!
            cell.configCell(top: CoreString._hv_help_visit_item_title,
                            details: CoreString._hv_help_visit_item_message,
                            left: image)
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.zeroMargin()
    }
}

// MARK: - UITableViewDelegate

extension HumanCheckHelpViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        var url: URL?
        switch indexPath.row {
        case 0: url = URL(string: "https://protonmail.com/support-form")
        case 1: url = viewModel.supportURL
        default: break
        }
        guard let validUrl = url else { return }
        UIApplication.shared.open(validUrl)
    }
}

#endif
