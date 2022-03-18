import UIKit

class ViewController: UIViewController {

    let hoursLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Hours"
        label.textColor = .fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    let minutesLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Minutes"
        label.textColor = .fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    let secondsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Seconds"
        label.textColor = .fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        return stackView
    }()
    
    let line: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "line.svg")
        imageView.image = image
        return imageView
    }()
    
    let startButton: UIButton = {
        let startButton = UIButton()
        
        startButton.backgroundColor = .mainColor
        startButton.setTitle("시작", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
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
        pauseButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 54, bottom: 15, right: 54)
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
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        resetButton.layer.shadowRadius = 4
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        return resetButton
    }()
    
    lazy var alarmButton: UIButton = {
        let alarmButton = UIButton()
        
        alarmButton.setImage(UIImage(named: "alarmButton.png"), for: .normal)
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        alarmButton.layer.shadowColor = UIColor(hex: 0xE06565).cgColor
        alarmButton.layer.shadowOpacity = 0.3
        alarmButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        alarmButton.layer.shadowRadius = 4
        alarmButton.translatesAutoresizingMaskIntoConstraints = false
        
        return alarmButton
    }()
    
    lazy var shapeView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "ellipse.svg")
        imageView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var timerLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.Roboto(type: .Light, size: 40)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let pickerView = UIPickerView()
    private let shapeLayer = CAShapeLayer()
    
    var timer: Timer?
    var isAlarmButtonTapped: Bool = false
    
    lazy var hours: Int = pickerView.selectedRow(inComponent: 0)
    lazy var minutes: Int = pickerView.selectedRow(inComponent: 2)
    lazy var seconds: Int = pickerView.selectedRow(inComponent: 4)
    
    lazy var durationTime: Int = ( hours * 3600 ) + ( minutes  * 60 ) + seconds
    lazy var remainingTime: Int = durationTime

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightBGColor
        
        navigationBar()
        setContraints()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.selectRow(0, inComponent: 2, animated: false)
        pickerView.selectRow(30, inComponent: 4, animated: false)
    }

    private func setContraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(hoursLabel)
        stackView.addArrangedSubview(minutesLabel)
        stackView.addArrangedSubview(secondsLabel)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(line)
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            line.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            line.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -70),
            startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        view.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            pickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            pickerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            pickerView.heightAnchor.constraint(equalToConstant: 350)
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

    func secondsToTime(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    
    // MARK: - Selectors
    @objc func startButtonTapped() {

        durationTime = ( hours * 3600 ) + ( minutes  * 60 ) + seconds
        remainingTime = durationTime
        
        runTimer()
        basicAnimation()
        
        timerLabel.text = secondsToTime(seconds: durationTime)
        
        let vc = UIViewController()
        vc.title = "타이머"
        vc.view.backgroundColor = .lightBGColor
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.navigationBar.tintColor = .fontColor
        navigationItem.backButtonTitle = ""
        
        let safeArea = vc.view.safeAreaLayoutGuide
        
        vc.view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -70),
            pauseButton.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor)
        ])

        vc.view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            resetButton.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: -15)
        ])

        vc.view.addSubview(alarmButton)
        NSLayoutConstraint.activate([
            alarmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            alarmButton.leadingAnchor.constraint(equalTo: pauseButton.trailingAnchor, constant: 15)
        ])

        shapeView.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        ])
        
        vc.view.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
    }
    
    @objc func pauseButtonTapped() {
        if pauseButton.currentTitle == "일시정지" {
            timer!.invalidate()
            pauseButton.setTitle("다시시작", for: .normal)
            shapeLayer.pauseAnimation()
        } else {
            if remainingTime <= 0 {
                
                durationTime = ( hours * 3600 ) + ( minutes  * 60 ) + seconds
                remainingTime = durationTime
                
                runTimer()
                basicAnimation()
                
                timerLabel.text = secondsToTime(seconds: durationTime)
            } else {
                runTimer()
                pauseButton.setTitle("일시정지", for: .normal)
                shapeLayer.resumeAnimation()
            }
            
        }
    }
    
    @objc func resetButtonTapped() {
        timerLabel.text = secondsToTime(seconds: durationTime)
        pauseButton.setTitle("다시시작", for: .normal)
        remainingTime = 0
        shapeLayer.resetAnimation()
//        basicAnimation()
    }
    
    @objc func alarmButtonTapped() {
        if isAlarmButtonTapped == false {
            isAlarmButtonTapped = true
            
            let alert = UIAlertController(title: "알림", message: "알람이 설정되었어요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
            present(alert,animated: true,completion: nil)
        } else {
            isAlarmButtonTapped = false
            
            let alert = UIAlertController(title: "알림", message: "알람이 해제되었어요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
            present(alert,animated: true,completion: nil)
        }
    }
    
    @objc func updateTimer() {
        if remainingTime <= 0 {
            timer!.invalidate()
            timer = nil
            pauseButton.setTitle("다시시작", for: .normal)
            remainingTime = 0
            
            if isAlarmButtonTapped == true {
                let alert = UIAlertController(title: "알림", message: "시간이 다됐어요! 🙌🏻", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
                present(alert,animated: true,completion: nil)
            }

        } else {
            remainingTime -= 1
            timerLabel.text = secondsToTime(seconds: remainingTime)
            
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
        shapeLayer.strokeColor = UIColor(hex: 0xE06565).cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeView.layer.addSublayer(shapeLayer)
    }

    func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTime)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}
