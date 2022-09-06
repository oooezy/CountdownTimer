//
//  CAShapeLayer + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/03/17.
//

import UIKit

extension CALayer {
    func pauseAnimation() {
        let pausedTime : CFTimeInterval = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0.0
        timeOffset = pausedTime

    }

    func resumeAnimation() {
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
    
    func resetAnimation() {
        removeAllAnimations()
    }

    func isPaused() -> Bool {
        return speed == 0
    }
}
