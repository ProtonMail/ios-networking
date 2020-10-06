//
//  ComposeErrorView.swift
//  ProtonMail - Created on 3/14/16.
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

class ComposeErrorView: PMView {
    @IBOutlet weak var errorLabel: UILabel!
    override func getNibName() -> String {
        return "ComposeErrorView"
    }
    
    func setError(_ msg : String, withShake : Bool) {
        errorLabel.text = msg
        errorLabel.backgroundColor = UIColor(hexColorCode: "#E84118")
        self.layoutIfNeeded()
        if withShake {
            errorLabel.shake(3, offset: 10)
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.isHidden = true
        }
    }
    
    func setOk(_ msg : String, withShake : Bool = false) {
        errorLabel.text = msg
        errorLabel.backgroundColor = UIColor(hexColorCode: "#44BD32")
        self.layoutIfNeeded()
        if withShake {
            errorLabel.shake(3, offset: 10)
        }
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8.0
    }
}
#endif