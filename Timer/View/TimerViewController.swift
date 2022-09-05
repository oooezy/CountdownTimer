//
//  SettingViewController.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit

import AVFoundation
import RxSwift
import SnapKit
import Then

class TimerViewController: UIViewController {
    private let viewModel = ViewModel()
    
    let shapeLayer = CAShapeLayer()
    var duration: TimeInterval = 30.0
    
    // MARK: - UI
    lazy var stopButton = UIButton().then {
        $0.setStateButtonUI(buttonTitle: "일시 정지")
        $0.accessibilityIdentifier = "stopButton"
        $0.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
    }
    
    lazy var resetButton = UIButton().then {
        $0.setCircleButtonUI(image: "resetButton")
        $0.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    lazy var alarmButton = UIButton().then {
        $0.setCircleButtonUI(image: "alarmButton")
        $0.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
    }
    
    lazy var shapeView = UIImageView().then {
        $0.image = UIImage.init(named: "ellipse.svg")
        $0.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
    }
    
    lazy var timeLabel = UILabel().then {
        $0.font = UIFont.Roboto(type: .Light, size: 40)
        $0.textColor = .mainColor
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "타이머"
        self.view.backgroundColor = UIColor.init(named: "BGColor")

        viewModel.delegate = self
        viewModel.duration = duration
        setContraints()
        
        timeLabel.text = viewModel.secondsToString(seconds: Int(duration))
        viewModel.start()
        basicAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.cancelTimer()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    // MARK: - Private
    private func setContraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        [stopButton, resetButton, alarmButton, shapeView, timeLabel].forEach({view.addSubview($0)})
        
        stopButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea.snp.bottom).offset(-70)
            make.centerX.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea.snp.bottom).offset(-72)
            make.trailing.equalTo(stopButton.snp.leading).offset(-16)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeArea.snp.bottom).offset(-72)
            make.leading.equalTo(stopButton.snp.trailing).offset(16)
        }
        
        shapeView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(shapeView.snp.centerX)
            make.centerY.equalTo(shapeView.snp.centerY)
        }
    }
    
    func updateViews(timeRemaining: String) {
        switch viewModel.state {
        case .started, .reset:
            timeLabel.text = timeRemaining
        case .stopped:
            timeLabel.text = "00:00:00"
        case .paused:
            timeLabel.text = viewModel.secondsToString(seconds: Int(viewModel.remainDuration))
        }
    }
    
    // MARK: - objc
    @objc func stopButtonTapped() {
        if stopButton.currentTitle == "일시 정지" {
            viewModel.pause()
            shapeLayer.pauseAnimation()
            stopButton.setTitle("다시 시작", for: .normal)
        } else if stopButton.currentTitle == "다시 시작"  {
            viewModel.restart()
            shapeLayer.resumeAnimation()
            stopButton.setTitle("일시 정지", for: .normal)
        } else if stopButton.currentTitle == "타이머 시작" {
            viewModel.start()
            basicAnimation()
            stopButton.setTitle("일시 정지", for: .normal)
        }
    }

    @objc func resetButtonTapped() {
        viewModel.start()
        timeLabel.text = viewModel.secondsToString(seconds: Int(duration))
        basicAnimation()
        stopButton.setTitle("일시 정지", for: .normal)
    }

    @objc func alarmButtonTapped() {
        let SettingVC = SettingViewController()
        if isAlarmButtonTapped == false {
            isAlarmButtonTapped = true
            SettingVC.alarmSwitch.setOn(true, animated: true)
            defaults.set(SettingVC.alarmSwitch.isOn, forKey: "alarmState")
            presentAlert(message: "알람이 설정되었어요")
        } else {
            isAlarmButtonTapped = false
            SettingVC.alarmSwitch.setOn(false, animated: true)
            defaults.set(false, forKey: "alarmState")
            presentAlert(message: "알람이 해제되었어요")
        }
    }

    // MARK: - Animation
    func animationCircular() {
        let center = CGPoint(x: shapeView.frame.size.width / 2, y: shapeView.frame.size.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle

        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 120,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: false)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.mainColor.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeView.layer.addSublayer(shapeLayer)
    }

    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(duration)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

// MARK: - Extension
extension TimerViewController: CountdownTimerDelegate {
    func timerDidFinish() {
        viewModel.cancelTimer()
        stopButton.setTitle("타이머 시작", for: .normal)

        if isAlarmButtonTapped == true {
            presentAlert(message: "시간이 다됐어요! 🙌🏻")
            UIDevice.vibrate()
        }
        
        timeLabel.text = viewModel.secondsToString(seconds: Int(duration))
    }
    
    func timerUpdate(timeRemaining: String) {
        updateViews(timeRemaining: timeRemaining)
    }
    
}
