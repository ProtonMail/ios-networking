//
//  UIView+Extension.swift
//  ProtonMail
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

extension UIView {
    @discardableResult func loadFromNib<T : UIView>() -> T? {
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: Common.bundle)

        guard let subview = nib.instantiate(withOwner: self, options: nil).first as? T else {
            return nil
        }
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        subview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        return subview
    }
    
    enum BorderSide: String {
        case top, bottom, left, right
    }
    
    func roundCorners(radius: CGFloat? = nil) {
        layer.cornerRadius = radius ?? 4.0
        clipsToBounds = true
    }
}
#endif
