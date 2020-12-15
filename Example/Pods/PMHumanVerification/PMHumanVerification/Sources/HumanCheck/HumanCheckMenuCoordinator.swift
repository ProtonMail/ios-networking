//
//  HumanCheckMenuCoordinator.swift
//  ProtonMail - Created on 8/20/19.
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
import PMUICommon

public class HumanCheckMenuCoordinator: ModalVCBasedCoordinator {
    public typealias ViewController = HumanCheckMenuViewController
    fileprivate let viewModel: HumanCheckViewModel

    lazy public var configuration: ((HumanCheckMenuViewController) -> Void)? = { viewController in
        viewController.set(coordinator: self)
        viewController.set(viewModel: self.viewModel)
    }
    public var rootViewController: UIViewController?
    public weak var viewController: ViewController?
    public var services: ServiceFactory
    public weak var delegate: CoordinatorDelegate?

    public init?(rootViewController: UIViewController?, viewModel: HumanCheckViewModel, services: ServiceFactory, scene: AnyObject? = nil) {
        if NSClassFromString("XCTest") != nil { return nil }
        self.rootViewController = rootViewController
        self.viewModel = viewModel
        self.services = services

        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: Common.bundle)
        guard let customViewController = storyboard.instantiateViewController(withIdentifier: "HumanCheckMenuViewController") as? HumanCheckMenuViewController else { return }
        self.viewController = customViewController
    }
}

#endif
