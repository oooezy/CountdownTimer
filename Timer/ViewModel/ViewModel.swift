//
//  ViewModel.swift
//  Timer
//
//  Created by 이은지 on 2022/03/28.
//

import UIKit
import RxCocoa
import RxSwift

protocol CountdownTimerDelegate: AnyObject {
    func timerUpdate(timeRemaining: String)
    func timerDidFinish()
}

class ViewModel {
    weak var delegate: CountdownTimerDelegate?
    private(set) var state: countdownTimerState

    var disposeBag = DisposeBag()
    var duration: TimeInterval
    var remainDuration: Int
    
    init() {
        duration = 0
        state = .reset
        remainDuration = 0
    }
    
    func runTimer() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { Int(self.duration) - ($0 + 1) }
            .take(until: { $0 == 0 }, behavior: .inclusive)
            .subscribe(onNext: { value in
                self.remainDuration = value
                let time = self.secondsToString(seconds: value)
                self.delegate?.timerUpdate(timeRemaining: time)
            }, onCompleted: {
                self.delegate?.timerDidFinish()
            })
            .disposed(by: disposeBag)
    }
    
    func replayTimer() {
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ in Int(self.remainDuration) - 1 }
            .take(until: { $0 == 0 }, behavior: .inclusive)
            .subscribe(onNext: { value in
                self.remainDuration = value
                let time = self.secondsToString(seconds: value)
                self.delegate?.timerUpdate(timeRemaining: time)
            }, onCompleted: {
                self.delegate?.timerDidFinish()
            })
            .disposed(by: disposeBag)
    }
    
    func start() {
        cancelTimer()
        state = .started
        runTimer()
   }
    
    func pause() {
        state = .paused
        cancelTimer()
    }
    
    func restart() {
        replayTimer()
        state = .started
    }

    func reset() {
        cancelTimer()
        state = .reset
    }
    
    func cancelTimer() {
        disposeBag = DisposeBag()
    }

    func secondsToString(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
}
