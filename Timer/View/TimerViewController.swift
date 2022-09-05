//
//  SettingViewController.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit
import RxSwift
import AVFoundation

class TimerViewController: UIViewController {
    private let viewModel = ViewModel()
    
    let shapeLayer = CAShapeLayer()
    var duration: TimeInterval = 30.0
    
    // MARK: - UI
    lazy var stopButton: UIButton = {
        let stopButton = UIButton()
        stopButton.setStateButtonUI(buttonTitle: "일시 정지")
        stopButton.accessibilityIdentifier = "stopButton"
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return stopButton
    }()
    
    lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        resetButton.setCircleButtonUI(image: "resetButton")
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return resetButton
    }()
    
    lazy var alarmButton: UIButton = {
        let alarmButton = UIButton()
        alarmButton.setCircleButtonUI(image: "alarmButton")
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        return alarmButton
    }()
    
    lazy var shapeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "ellipse.svg")
        imageView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        return imageView
    }()
    
    lazy var timeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.Roboto(type: .Light, size: 40)
        label.textColor = .mainColor

        return label
    }()
    
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
        [shapeView, timeLabel].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        NSLayoutConstraint.activate([
            stopButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -70),
            stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            resetButton.trailingAnchor.constraint(equalTo: stopButton.leadingAnchor, constant: -16)
        ])

        NSLayoutConstraint.activate([
            alarmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            alarmButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        ])
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
