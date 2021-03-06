//
//  CAShapeLayer + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/03/17.
//

import UIKit

extension CAShapeLayer {
    func pauseAnimation() {
        if isPaused() == false {
            let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
            speed = 0.0
            timeOffset = pausedTime
        }
    }

    func resumeAnimation() {
        if isPaused() {
            let pausedTime = timeOffset
            speed = 1.0
            timeOffset = 0.0
            beginTime = 0.0
            let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            beginTime = timeSincePause
        }
    }
    
    func resetAnimation() {
        removeAllAnimations()
    }

    func isPaused() -> Bool {
        return speed == 0
    }
}
