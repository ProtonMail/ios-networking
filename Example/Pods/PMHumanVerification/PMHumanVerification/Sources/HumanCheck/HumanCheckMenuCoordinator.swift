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

public class HumanCheckMenuCoordinator: PushCoordinator {
    public typealias VC = HumanCheckMenuViewController
    fileprivate let viewModel : HumanCheckViewModel
    
    lazy public var configuration: ((HumanCheckMenuViewController) -> ())? = { vc in
        vc.set(coordinator: self)
        vc.set(viewModel: self.viewModel)
    }
    public var navigationController: UINavigationController?
    public weak var viewController: VC?
    public var services: ServiceFactory
    public var delegate: CoordinatorDelegate? = nil
    
    public init?(nav: UINavigationController?, vm: HumanCheckViewModel, services: ServiceFactory, scene: AnyObject? = nil) {
        if let _ = NSClassFromString("XCTest") { return nil }
        self.navigationController = nav
        self.viewModel = vm
        self.services = services

        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: Common.bundle)
        guard let customViewController = storyboard.instantiateViewController(withIdentifier: "HumanCheckMenuViewController") as? HumanCheckMenuViewController else { return }
        self.viewController = customViewController
    }
}

#endif
