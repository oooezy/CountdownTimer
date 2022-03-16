//
//  ViewController.swift
//  Timer
//
//  Created by 이은지 on 2022/03/14.
//

import UIKit

class ViewController: UIViewController {
    private let pickerView = UIPickerView()
    
    var timer: Timer?
    
    let shapeLayer = CAShapeLayer()
    
    var durationTimer = 60
    var isTimerRunning = false
    
//    print("\(pickerView.selectedRow(inComponent: 0)):\(pickerView.selectedRow(inComponent: 2)):\( pickerView.selectedRow(inComponent: 4))")
    
    
    var hours: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    var minSec: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    lazy var hoursLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Hours"
        label.textColor = .fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    lazy var minutesLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Minutes"
        label.textColor = .fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    lazy var secondsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Seconds"
        label.textColor = .fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        return stackView
    }()
    
    lazy var startButton: UIButton = {
        let startButton = UIButton()
        
        startButton.backgroundColor = .mainColor
        startButton.setTitle("시작", for: .normal)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        startButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 64, bottom: 15, right: 64)
        startButton.layer.cornerRadius = 25
        startButton.layer.shadowColor = UIColor(hex: 0xE06565).cgColor
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        startButton.layer.shadowRadius = 8
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        return startButton
    }()
    
    lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        
        pauseButton.backgroundColor = .mainColor
        pauseButton.setTitle("일시정지", for: .normal)
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        pauseButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 64, bottom: 15, right: 64)
        pauseButton.layer.cornerRadius = 25
        pauseButton.layer.shadowColor = UIColor(hex: 0xE06565).cgColor
        pauseButton.layer.shadowOpacity = 0.3
        pauseButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        pauseButton.layer.shadowRadius = 8
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
    
        return pauseButton
    }()
    
    lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        
        resetButton.setImage(UIImage(named: "resetButton.png"), for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        resetButton.layer.shadowColor = UIColor(hex: 0xE06565).cgColor
        resetButton.layer.shadowOpacity = 0.3
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        resetButton.layer.shadowRadius = 8
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        return resetButton
    }()
    
    lazy var alarmButton: UIButton = {
        let alarmButton = UIButton()
        
        alarmButton.setImage(UIImage(named: "alarmButton.png"), for: .normal)
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        alarmButton.layer.shadowColor = UIColor(hex: 0xE06565).cgColor
        alarmButton.layer.shadowOpacity = 0.3
        alarmButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        alarmButton.layer.shadowRadius = 8
        alarmButton.translatesAutoresizingMaskIntoConstraints = false
        
        return alarmButton
    }()
    
    let shapeView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "ellipse.svg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Roboto(type: .Light, size: 40)
        label.textColor = UIColor.systemPink
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.text = "\(durationTimer)"
        
        view.backgroundColor = .lightBGColor
        
        navigationBar()
        setContraints()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setContraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(hoursLabel)
        stackView.addArrangedSubview(minutesLabel)
        stackView.addArrangedSubview(secondsLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -100),
            startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        view.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 150),
            pickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            pickerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        pickerView.translatesAutoresizingMaskIntoConstraints = false
    }

    func navigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [.foregroundColor: UIColor(hex: 0xA3A3A3)]
        
        self.navigationItem.title = "타이머"
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: - Selectors
    @objc func didTapStartButton() {
        
        runTimer()
        basicAnimation()
        
        print("\(pickerView.selectedRow(inComponent: 0)):\(pickerView.selectedRow(inComponent: 2)):\( pickerView.selectedRow(inComponent: 4))")
        
        let vc = UIViewController()
        vc.title = "타이머"
        vc.view.backgroundColor = .lightBGColor
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.navigationBar.tintColor = .fontColor
        navigationItem.backButtonTitle = ""
        
        vc.view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -150),
            pauseButton.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor)
        ])
        
        vc.view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -150),
            resetButton.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 30)
        ])

        
        vc.view.addSubview(alarmButton)
        NSLayoutConstraint.activate([
            alarmButton.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -150),
            alarmButton.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -30)
        ])

        shapeView.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        ])
        
        vc.view.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 250),
            shapeView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    @objc func updateTimer() {
        durationTimer -= 1
        timerLabel.text = "\(durationTimer)" // data
        
        if durationTimer <= 0 {
            timer!.invalidate()
            timer = nil
            pauseButton.setTitle("다시시작", for: .normal)
            durationTimer = 60 // data
        }
    }
    
    @objc func pauseButtonTapped() {
        if pauseButton.currentTitle == "일시정지" {
            timer!.invalidate()
            pauseButton.setTitle("다시시작", for: .normal)
        } else {
            runTimer()
            pauseButton.setTitle("일시정지", for: .normal)
        }
    }
    
    @objc func resetButtonTapped() {
        durationTimer = 60 // data
        timerLabel.text = "\(durationTimer)"
    }
    
    @objc func alarmButtonTapped() {
        
    }
    
    // MARK: - Animation
    func animationCircular() {
        
        let center = CGPoint(x: shapeView.frame.width / 2, y: shapeView.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        
        let circularPath = UIBezierPath(arcCenter: center, radius: 128, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor(hex: 0xE06565).cgColor
        shapeView.layer.addSublayer(shapeLayer)
    }

    func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

// MARK: - Extensions
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 88
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
        case 0:
            return hours.count
        case 1, 3:
            return 1;
        case 2, 4:
            return minSec.count
        default:
            return 1;
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let setTime = UILabel(frame: CGRect(x: 0, y: 0, width: 54, height: 56))
        setTime.text = {
            switch (component) {
            case 0:
                return hours[row]
            case 2, 4:
                return minSec[row]
            case 1, 3:
                return ":"
            default:
                return ""
            }
        }()
        setTime.textColor = (row == pickerView.selectedRow(inComponent: component)) ? .mainColor : .fontColor
        setTime.textAlignment = .center
        setTime.font = UIFont.Roboto(type: .Light, size: 40)
        
        return setTime
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(component)
    }
}
