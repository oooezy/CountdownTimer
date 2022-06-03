//
//  UILabel + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit

extension UILabel {
    func setLabelUI(text: String, type: UIFont.RobotoType, size: Int) {
        let label = self
        label.text = text
        label.font = UIFont.Roboto(type: type, size: CGFloat(size))
        label.textColor = UIColor.fontColor
    }
}
