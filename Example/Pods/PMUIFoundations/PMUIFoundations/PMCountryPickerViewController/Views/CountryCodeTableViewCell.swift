//
//  CountryCodeTableViewCell.swift
//  ProtonMail - Created on 12.03.21.
//
//  Copyright (c) 2021 Proton Technologies AG
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

class CountryCodeTableViewCell: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.contentMode = .scaleAspectFit
        flagImageView.layer.cornerRadius = 4
        flagImageView.layer.masksToBounds = true
        countryLabel.textColor = UIColorManager.TextNorm
        codeLabel.textColor = UIColorManager.TextWeak
    }

    func configCell(_ countryCode: CountryCode) {
        let image = UIImage(named: "flags-\(countryCode.country_code)", in: PMUIFoundations.bundle, compatibleWith: nil)
        flagImageView.image = image
        countryLabel.text = countryCode.country_en
        codeLabel.text = "+ \(countryCode.phone_code)"
    }
}
