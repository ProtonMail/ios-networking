//
//  TextInsetTextField.swift
//  PMLogin
//
//  Created by Igor Kulman on 03/11/2020.
//

import Foundation
import UIKit

final class PMInternalTextField: UITextField {

    // MARK: - Properties

    var isError: Bool = false {
        didSet {
            setBorder()
        }
    }

    var suffixMarging: CGFloat = 0

    private let topBottomInset: CGFloat = 13
    private let leftRightInset: CGFloat = 12

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.masksToBounds = true
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = UIColorManager.InteractionWeakDisabled.cgColor
    }

    override var clearButtonMode: UITextField.ViewMode {
        didSet {
            setNeedsDisplay()
        }
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rightPadding: CGFloat = clearButtonMode == .whileEditing ? 16 : 0
        return CGRect(x: bounds.origin.x + topBottomInset, y: bounds.origin.y + leftRightInset, width: bounds.size.width - 2 * leftRightInset - rightPadding - suffixMarging, height: bounds.size.height - 2 * topBottomInset)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + topBottomInset, y: bounds.origin.y + leftRightInset, width: bounds.size.width - 2 * leftRightInset - suffixMarging, height: bounds.size.height - 2 * topBottomInset)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setBorder()
    }

    // MARK: - Actions

    func setBorder() {
        if isError {
            layer.borderColor = UIColorManager.NotificationError.cgColor
            return
        }

        layer.borderColor = isEditing ? UIColorManager.BrandNorm.cgColor : UIColorManager.InteractionWeakDisabled.cgColor
    }
}
