//
//  CoordinatorNew.swift
//  ProtonMail - Created on 10/29/18.
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


public protocol CoordinatorDelegate: class {
    func willStop(in coordinator: Coordinator)
    func didStop(in coordinator: Coordinator)
}

public protocol CoordinatedBase : AnyObject {
    func getCoordinator() -> Coordinator?
}

/// Used typically on view controllers to refer to it's coordinator
public protocol Coordinated : CoordinatedBase where coordinatorType: Coordinator {
    associatedtype coordinatorType
    func set(coordinator: coordinatorType)
}

public protocol CoordinatedAlerts {
    func controller(notFount dest: String)
}

public protocol Coordinator : AnyObject {
    /// Triggers navigation to the corresponding controller
    /// set viewmodel and coordinator when call start
    func start()
    
    /// Stops corresponding controller and returns back to previous one
    func stop()
    
    /// Called when segue navigation form corresponding controller to different controller is about to start and should handle this navigation
    func navigate(from source: UIViewController, to destination: UIViewController, with identifier: String?, and sender: AnyObject?) -> Bool
}

/// Navigate and stop methods are optional
extension Coordinator {
    public func navigate(from source: UIViewController, to destination: UIViewController, with identifier: String?, and sender: AnyObject?) -> Bool {
        return false
    }
    
    public func stop() {
        
    }
}


/// The default coordinator is for the segue perform handled by system. need to return true in navigat function to trigger. if return false, need to push in the start().
public protocol DefaultCoordinator: Coordinator {
    associatedtype VC: UIViewController
    var viewController: VC? { get set }
    
    var animated: Bool { get }
    var delegate: CoordinatorDelegate? { get }
    
    var services: ServiceFactory {get}
    
    func follow(_ deepLink: DeepLink)
    func processDeepLink()
}


public protocol PushCoordinator: DefaultCoordinator {
    var configuration: ((VC) -> ())? { get }
    var navigationController: UINavigationController? { get }
}

extension PushCoordinator where VC: UIViewController, VC: Coordinated {
    public func start() {
        guard let viewController = viewController else {
            return
        }
        configuration?(viewController)
        viewController.set(coordinator: self as! Self.VC.coordinatorType)
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else {
            let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
            window?.rootViewController?.show(viewController, sender: self)
        }
    }
    
    public func stop() {
        delegate?.willStop(in: self)
        navigationController?.popViewController(animated: animated)
        delegate?.didStop(in: self)
    }
}

public protocol ModalCoordinator: DefaultCoordinator {
    var configuration: ((VC) -> ())? { get }
    var navigationController: UINavigationController? { get }
    var destinationNavigationController: UINavigationController? { get }
}

extension ModalCoordinator where VC: UIViewController, VC: Coordinated {
    public func start() {
        guard let viewController = viewController else {
            return
        }
        
        configuration?(viewController)
        viewController.set(coordinator: self as! Self.VC.coordinatorType)
        
        if let destinationNavigationController = destinationNavigationController {
            // wrapper navigation controller given, present it
            navigationController?.present(destinationNavigationController, animated: animated, completion: nil)
        } else {
            // no wrapper navigation controller given, present actual controller
            navigationController?.present(viewController, animated: animated, completion: nil)
        }
    }
    
    public func stop() {
        delegate?.willStop(in: self)
        viewController?.dismiss(animated: true, completion: {
            self.delegate?.didStop(in: self)
        })
    }
}


protocol PushModalCoordinator: DefaultCoordinator {
    var configuration: ((VC) -> ())? { get }
    var navigationController: UINavigationController? { get }
    var destinationNavigationController: UINavigationController? { get }
}

extension DefaultCoordinator {
    // default implementation if not overriden
    public var animated: Bool {
        get {
            return true
        }
    }
    
    // default implementation of nil delegate, should be overriden when needed
    weak var delegate: CoordinatorDelegate? {
        get {
            return nil
        }
    }
    
    /// optional go with deeplink
    ///
    /// - Parameter deepLink: deepLipublic nk
    public func follow(_ deepLink: DeepLink) {
        
    }
    
    /// if add deeplinks could handle here
    public func processDeepLink() {
        
    }
}
#endif
