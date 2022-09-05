//
//  UIDevice + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/09/06.
//

import UIKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
