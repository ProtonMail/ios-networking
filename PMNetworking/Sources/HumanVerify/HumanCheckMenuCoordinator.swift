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
    

import Foundation


public class HumanCheckMenuCoordinator: PushCoordinator {
    lazy public var configuration: ((HumanCheckMenuViewController) -> ())? = { vc in
        vc.set(coordinator: self)
        vc.set(viewModel: self.viewModel)
    }
    
    public var navigationController: UINavigationController?
    
    public typealias VC = HumanCheckMenuViewController
    
    weak public var viewController: VC?
    let viewModel : HumanCheckViewModel
    public var services: ServiceFactory
    
    public var delegate: CoordinatorDelegate? = nil
    
    public var checkDelegate: ((Bool) -> Void)?
    
    enum Destination : String {
        case addAccount = "toAddAccountSegue"
    }
    
    public init?(nav: UINavigationController, vm: HumanCheckViewModel, services: ServiceFactory, scene: AnyObject? = nil) {
        // this part of code will be in the framework
        self.navigationController = nav
        self.viewModel = vm
        self.services = services
        ///
        let bundle = Bundle(for: VC.self)
        let storyboard = UIStoryboard.init(name: "HumanVerify", bundle: bundle)
        guard let customViewController = storyboard.instantiateViewController(withIdentifier: "HumanCheckMenuViewController") as? HumanCheckMenuViewController else {
            print("bad")
            return
        }
        self.viewController = customViewController
    }
    
    public func stop() {
        delegate?.willStop(in: self)
        if self.viewController?.presentingViewController != nil {
            self.viewController?.dismiss(animated: true, completion: nil)
        } else {
            let _ = self.viewController?.navigationController?.popViewController(animated: true)
        }
        delegate?.didStop(in: self)
    }
    
    func go(to dest: Destination, sender: Any? = nil) {
        switch dest {
        default:
            self.viewController?.performSegue(withIdentifier: dest.rawValue, sender: sender)
        }
    }
    
    public func navigate(from source: UIViewController,
                         to destination: UIViewController, with identifier: String?, and sender: AnyObject?) -> Bool {
//        guard let segueID = identifier, let dest = Destination(rawValue: segueID) else {
//            return false //
//        }
//        switch dest {
//        case .addAccount:
//            let preFilledUsername = (sender as? UsersManager.DisconnectedUserHandle)?.defaultEmail
//            guard let account = AccountConnectCoordinator(vc: destination,
//                                                          vm: SignInViewModel(usersManager: self.services.get(), username: preFilledUsername),
//                                                          services: self.services) else {
//                return false
//            }
//            account.delegate = self
//            account.start()
//            return true
//        default:
//            return false
//        }
        return false
    }
}

extension HumanCheckMenuCoordinator: CoordinatorDelegate {
    public func willStop(in coordinator: Coordinator) {
        
    }
    
    public func didStop(in coordinator: Coordinator) {
        self.stop()
    }
}
