//
//  UISwitch + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit

extension UISwitch {
    func setSwitchUI() {
        let settingSwitch = self
        settingSwitch.onTintColor = .mainColor
        settingSwitch.setOn(false, animated: true)
    }
}
