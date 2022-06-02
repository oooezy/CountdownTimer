//
//  SettingViewController.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit

class TimerViewController: UIViewController {
    
    let shapeLayer = CAShapeLayer()
    let countdownTimer = ViewModel()
    var duration: TimeInterval = 0.0
    
    lazy var stopButton: UIButton = {
        let stopButton = UIButton()

        stopButton.stateButtonUI(buttonTitle: "타이머 종료")
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)

        return stopButton
    }()
    
    lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        
        resetButton.circleButtonUI(image: "resetButton")
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        return resetButton
    }()
    
    lazy var alarmButton: UIButton = {
        let alarmButton = UIButton()
        
        alarmButton.circleButtonUI(image: "alarmButton")
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        
        return alarmButton
    }()
    
    lazy var shapeView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.init(named: "ellipse.svg")
        imageView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var timeLabel: UILabel = {
        var label = UILabel()
        
        label.font = UIFont.Roboto(type: .Light, size: 40)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "타이머"
        self.view.backgroundColor = UIColor.init(named: "BGColor")
        navigationItem.backButtonTitle = ""
        countdownTimer.delegate = self
        setContraints()
        
        if stopButton.currentTitle == "타이머 시작" {
            stopButton.setTitle("타이머 종료", for: .normal)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    private func setContraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            stopButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -70),
            stopButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])

        view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            resetButton.trailingAnchor.constraint(equalTo: stopButton.leadingAnchor, constant: -16)
        ])

        view.addSubview(alarmButton)
        NSLayoutConstraint.activate([
            alarmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            alarmButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor, constant: 16)
        ])

        view.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        
        shapeView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        ])
    }
    
    func updateViews() {
        switch countdownTimer.state {
        case .started:
            timeLabel.text = countdownTimer.secondsToString(seconds: Int(countdownTimer.timeRemaining))
        case .stopped:
            timeLabel.text = countdownTimer.secondsToString(seconds: 0)
        case .reset:
            timeLabel.text = countdownTimer.secondsToString(seconds: Int(countdownTimer.timeRemaining))
        }
    }
    
    @objc func stopButtonTapped() {
        if stopButton.currentTitle == "타이머 종료" {
            self.navigationController?.popViewController(animated: true)
        } else {
            countdownTimer.start()
            updateViews()
            basicAnimation()
            stopButton.setTitle("타이머 종료", for: .normal)
        }
    }

    @objc func resetButtonTapped() {
        countdownTimer.reset()
        updateViews()
        shapeLayer.resetAnimation()
        stopButton.setTitle("타이머 시작", for: .normal)
    }

    @objc func alarmButtonTapped() {
        if isAlarmButtonTapped == false {
            isAlarmButtonTapped = true
            alarmSwitch.setOn(true, animated: true)
            defaults.set(alarmSwitch.isOn, forKey: "alarmState")
            presentAlert(message: "알람이 설정되었어요")
        } else {
            isAlarmButtonTapped = false
            alarmSwitch.setOn(false, animated: true)
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

extension TimerViewController: CountdownTimerDelegate {
    func timerDidFinish() {
        updateViews()
        stopButton.setTitle("타이머 시작", for: .normal)
        
        if isAlarmButtonTapped == true {
            presentAlert(message: "시간이 다됐어요! 🙌🏻")
        }
    }
    
    func timerDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
    }
}
