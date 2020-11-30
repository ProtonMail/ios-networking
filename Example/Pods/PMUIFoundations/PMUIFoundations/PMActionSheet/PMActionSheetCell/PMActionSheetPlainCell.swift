//
//  PMActionSheetPlainCell.swift
//  ProtonMail - Created on 23.07.20.
//
//  Copyright (c) 2020 Proton Technologies AG
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
//

import UIKit

class PMActionSheetPlainCell: UITableViewCell {

    private var separator: UIView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.separator = self.addSeparator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PMActionSheetPlainCell {
    func config(item: PMActionSheetPlainItem) {
        self.imageView?.image = item.icon
        self.imageView?.tintColor = item.iconColor
        self.textLabel?.text = item.title
        self.textLabel?.textColor = item.textColor
        self.textLabel?.textAlignment = item.alignment
        self.separator?.isHidden = !item.hasSeparator
        self.accessoryType = item.isOn ? .checkmark: .none
        self.accessibilityIdentifier = item.title
    }
}
