//
//  UIFont + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/03/16.
//

import UIKit

extension UIFont {
    class func Roboto(type: RobotoType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }

    public enum RobotoType {
        case Light
        case Medium
        case Regular
        
        var name: String {
            switch self {
            case .Light:
                return "Roboto-Light"
            case .Medium:
                return "Roboto-Medium"
            case .Regular:
                return "Roboto-Regular"
            }
        }
    }
}
