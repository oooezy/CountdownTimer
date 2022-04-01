//
//  UIColor + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/03/16.
//

import UIKit

extension UIColor {
    
    static let mainColor = UIColor(hex: 0xFA5656)
    static let fontColor = UIColor(hex: 0xA3A3A3)
    static let lightBGColor = UIColor(hex: 0xFAFAFA)
    
    // RGB값으로 색 생성
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // hex 값으로 색 생성
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}
