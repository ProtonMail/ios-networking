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
import PMCommon
import PMUICommon
import PMUIFoundations
import PMCoreTranslation

final public class HumanCheckMenuViewController: UIViewController, ViewModelProtocol, PMUICommon.Coordinated {

    // MARK: - Outlets

    @IBOutlet weak var helpBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeBarButtonItem: UIBarButtonItem!

    public typealias ViewModelType = HumanCheckViewModel
    public typealias CoordinatorType = HumanCheckMenuCoordinator
    private var viewModel: HumanCheckViewModel!
    private var coordinator: CoordinatorType?
    public func getCoordinator() -> PMUICommon.Coordinator? {
        return self.coordinator
    }
    public func set(coordinator: HumanCheckMenuCoordinator) {
        self.coordinator = coordinator
    }
    public func set(viewModel: HumanCheckViewModel) {
        self.viewModel = viewModel
    }

    fileprivate let kSegueToRecaptcha = "check_menu_to_recaptcha_verify_segue"
    fileprivate let kSegueToEmailVerify = "check_menu_to_email_verify_segue"
    fileprivate let kSegueToPhoneVerify = "check_menu_to_phone_verify_segue"
    fileprivate let kSegueToHelp = "check_menu_to_help_segue"

    public func setViewModel(viewModel: HumanCheckViewModel) {
        self.viewModel = viewModel
    }

    // MARK: View controller life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Actions

    @IBAction func unwindSegue( _ seg: UIStoryboardSegue) {
        configureUI()
    }

    @IBAction func helpAction(_ sender: Any) {
        self.performSegue(withIdentifier: self.kSegueToHelp, sender: self)
    }

    @IBAction func closeAction(_ sender: Any) {
        viewModel.close()
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Private Interface

    fileprivate func configureUI() {
        closeBarButtonItem.tintColor = UIColorManager.IconNorm
        view.backgroundColor = UIColorManager.BackgroundNorm
        self.title = CoreString._hv_title
        helpBarButtonItem.title = CoreString._hv_help_button
        helpBarButtonItem.tintColor = UIColorManager.BrandNorm
        segmentControl.removeAllSegments()
        segmentControl.backgroundColor = UIColorManager.SeparatorNorm
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColorManager.TextNorm], for: .selected)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColorManager.TextNorm], for: .normal)
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = UIColorManager.BackgroundNorm
        } else {
            segmentControl.tintColor = UIColorManager.BackgroundNorm
        }

        for (index, value) in self.viewModel.verifyTypes.enumerated() {
            segmentControl.insertSegment(withTitle: value.localizedTitle, at: index, animated: false)
        }
        segmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)

        // Select First Segment
        segmentControl.selectedSegmentIndex = 0
        navigationController?.hideBackground()
        updateView()
    }

    private var capcha: RecaptchaViewController {
        // Load Storyboard
        let bundle = Common.bundle
        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: bundle)
        let customViewController = storyboard.instantiateViewController(withIdentifier: "RecaptchaViewController") as! RecaptchaViewController
        // Add View Controller as Child View Controller
        customViewController.viewModel = self.viewModel
        self.add(asChildViewController: customViewController)
        return customViewController
    }

    private lazy var email: EmailVerifyViewController = {
        // Load Storyboard
        let bundle = Common.bundle
        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: bundle)
        let customViewController = storyboard.instantiateViewController(withIdentifier: "EmailVerifyViewController") as! EmailVerifyViewController
        // Add View Controller as Child View Controller
        customViewController.viewModel = self.viewModel
        self.add(asChildViewController: customViewController)
        return customViewController
    }()

    private lazy var sms: PhoneVerifyViewController = {
        // Load Storyboard
        let bundle = Common.bundle
        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: bundle)
        let customViewController = storyboard.instantiateViewController(withIdentifier: "PhoneVerifyViewController") as! PhoneVerifyViewController
        // Add View Controller as Child View Controller
        customViewController.viewModel = self.viewModel
        self.add(asChildViewController: customViewController)
        return customViewController
    }()

    @objc fileprivate func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }

    var lastViewController: UIViewController?

    fileprivate func updateView() {
        let index = segmentControl.selectedSegmentIndex
        let item = self.viewModel.verifyTypes[index]
        if let viewController = lastViewController {
            self.remove(asChildViewController: viewController)
            viewController.dismiss(animated: false)
            lastViewController = nil
        }
        switch item {
        case .email:
            self.add(asChildViewController: email)
        case .captcha:
            self.add(asChildViewController: capcha)
        case .sms:
            self.add(asChildViewController: sms)
        default:
            break
        }
        if let viewController = children.last {
            lastViewController = viewController
        }
    }

    fileprivate func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }

    fileprivate func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChild(viewController)
        // Add Child View as Subview
        self.containerView .addSubview(viewController.view)
        // Configure Child View
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kSegueToHelp {
            let viewController = segue.destination as! HumanCheckHelpViewController
            viewController.viewModel = self.viewModel
        }
    }
}

extension VerifyMethod {
    var localizedTitle: String {
        switch self {
        case .sms:
            return CoreString._hv_sms_method_name
        case .email:
            return CoreString._hv_email_method_name
        case .captcha:
            return CoreString._hv_captha_method_name
        default:
            return ""
        }
    }
}

#endif
