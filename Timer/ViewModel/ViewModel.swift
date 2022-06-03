//
//  ViewModel.swift
//  Timer
//
//  Created by 이은지 on 2022/03/28.
//
import Foundation

protocol CountdownTimerDelegate: AnyObject {
    func timerDidUpdate(timeRemaining: TimeInterval)
    func timerDidFinish()
}

enum countdownTimerState {
    case started
    case stopped
    case reset
}

class ViewModel {
    weak var delegate: CountdownTimerDelegate?
    private(set) var state: countdownTimerState
    private var timer: Timer?
    private var stopTime: Date?
    
    var duration: TimeInterval
    var timeRemaining: TimeInterval {
            if let stopTime = stopTime {
                print(stopTime)
                let timeRemaining = stopTime.timeIntervalSinceNow
                return timeRemaining
            } else {
                return 0
            }
        }
    
    init() {
        timer = nil
        stopTime = nil
        duration = 0
        state = .reset
    }
        
    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: updateTimer(timer:))
    }
    
    func start() {
        cancelTimer()
        runTimer()
        stopTime = Date(timeIntervalSinceNow: duration)
        state = .started
   }

    func reset() {
        cancelTimer()
        stopTime = nil
        state = .reset
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    func secondsToString(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    func updateTimer(timer: Timer) {
        if let stopTime = stopTime {
            let currentTime = Date()
            if currentTime <= stopTime {
                delegate?.timerDidUpdate(timeRemaining: timeRemaining)
            } else {
                state = .stopped
                cancelTimer()
                self.stopTime = nil
                delegate?.timerDidFinish()
            }
        }
    }
}
