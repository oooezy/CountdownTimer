////
////  BaseViewController.swift
////  Timer
////
////  Created by 이은지 on 2022/03/18.
////
//
//import Foundation
//
//class ViewModel {
//    let state: Model.timerState
//    let timeString: String
//    let buttonText: String
//    
//    init(state: Model.timerState) {
//        self.state = state
//        
//        switch self.state {
//        case .started(let data):
//            self.timeString = String(data.durationTime)
//            self.buttonText = "일시정지"
//        case .paused(let data):
//            self.timeString = String(data.remainingTime)
//            self.buttonText = "다시시작"
//        case .finished(let data):
//            self.timeString = String(data.durationTime)
//            self.buttonText = "다시시작"
//        }
//    }
//    
//    func buttonTapped() -> ViewModel {
//        switch self.state {
//        case .started(let data):
//            return ViewModel(state: .started(data))
//        case .paused(let data):
//            return ViewModel(state: .paused(data))
//        case .finished(let data):
//            return ViewModel(state: .started(data))
//        }
//    }
//    
//    private func secondsToString(seconds: Int) -> String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.zeroFormattingBehavior = .pad
//        formatter.unitsStyle = .positional
//        
//        return formatter.string(from: TimeInterval(seconds))!
//    }
//
//}
//
//// 화면에서 보여져야될값 = View를 위한 Model
//// Model -> ViewModel
