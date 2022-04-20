import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    let table: UITableView = {
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = UIColor.init(named: "BGColor")
        table.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 1
        }

        return table
    }()
    
    lazy var modeSwitch: UISwitch = {
        let modeSwitch = UISwitch(frame: .zero)
        
        modeSwitch.onTintColor = .mainColor
        modeSwitch.setOn(false, animated: true)
        modeSwitch.addTarget(self, action: #selector(modeSwitchChanged(_:)), for: .valueChanged)
        
        return modeSwitch
    }()
    
    lazy var alarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch(frame: .zero)
        
        alarmSwitch.onTintColor = .mainColor
        alarmSwitch.setOn(false, animated: true)
        alarmSwitch.addTarget(self, action: #selector(alarmSwitchChanged(_:)), for: .valueChanged)
        
        return alarmSwitch
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let line: UIImageView = {
        let imageView = UIImageView()
        
        let image = UIImage(named: "line.svg")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
 
    private let startButton: UIButton = {
        let startButton = UIButton()
        
        startButton.backgroundColor = .mainColor
        startButton.setTitle("타이머 시작", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 54, bottom: 15, right: 54)
        startButton.layer.cornerRadius = 25
        startButton.layer.shadowColor = UIColor.mainColor.cgColor
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        startButton.layer.shadowRadius = 8
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        return startButton
    }()
    
    private lazy var stopButton: UIButton = {
        let stopButton = UIButton()

        stopButton.backgroundColor = .mainColor
        stopButton.setTitle("타이머 종료", for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        stopButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 54, bottom: 15, right: 54)
        stopButton.layer.cornerRadius = 25
        stopButton.layer.shadowColor = UIColor.mainColor.cgColor
        stopButton.layer.shadowOpacity = 0.3
        stopButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        stopButton.layer.shadowRadius = 8
        stopButton.translatesAutoresizingMaskIntoConstraints = false

        return stopButton
    }()
    
    private lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        
        resetButton.setImage(UIImage(named: "resetButton.png"), for: .normal)
        resetButton.contentMode = .scaleAspectFit
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        resetButton.layer.shadowColor = UIColor.mainColor.cgColor
        resetButton.layer.shadowOpacity = 0.3
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        resetButton.layer.shadowRadius = 4
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        return resetButton
    }()
    
    private lazy var alarmButton: UIButton = {
        let alarmButton = UIButton()
        
        alarmButton.setImage(UIImage(named: "alarmButton.png"), for: .normal)
        alarmButton.contentMode = .scaleAspectFit
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped), for: .touchUpInside)
        alarmButton.layer.shadowColor = UIColor.mainColor.cgColor
        alarmButton.layer.shadowOpacity = 0.3
        alarmButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        alarmButton.layer.shadowRadius = 4
        alarmButton.translatesAutoresizingMaskIntoConstraints = false
        
        return alarmButton
    }()
    
    private lazy var pickerView = UIPickerView()
    
    private lazy var shapeView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage.init(named: "ellipse.svg")
        imageView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var timeLabel: UILabel = {
        var label = UILabel()
        
        label.font = UIFont.Roboto(type: .Light, size: 40)
        label.textColor = .mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    
    // MARK: - Properties
    
    var defaults = UserDefaults.standard
    var isAlarmButtonTapped: Bool = false
    
    private let shapeLayer = CAShapeLayer()
    
    lazy var pickerViewData: [[String]] = {
        let hours: [String] = Array(0...24).map { String($0) }
        let minutes: [String] = Array(0...59).map { String($0) }
        let seconds: [String] = Array(0...59).map { String($0) }

        let data: [[String]] = [hours, [":"], minutes, [":"], seconds]
        return data
    }()
    
    var duration: TimeInterval {
        let hoursString = pickerView.selectedRow(inComponent: 0)
        let minutesString = pickerView.selectedRow(inComponent: 2)
        let secondsString = pickerView.selectedRow(inComponent: 4)
        
        let hours = Int(hoursString)
        let minutes = Int(minutesString)
        let seconds = Int(secondsString)
        
        let totalSeconds = TimeInterval(( hours * 3600 ) + ( minutes  * 60 ) + seconds)
        return totalSeconds
    }
    
    let countdownTimer = CountdownTimer()
    
    let settingList: [String] = ["다크모드 설정", "알람 설정"]
    let etcList: [String] = ["버전"]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(named: "BGColor")
        
        navigationBar()
        setContraints()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.selectRow(0, inComponent: 2, animated: false)
        pickerView.selectRow(30, inComponent: 4, animated: false)
        
        countdownTimer.duration = duration
        countdownTimer.delegate = self
        
        table.delegate = self
        table.dataSource = self
        
        updateViews()
        configureItems()
        navigationController?.navigationBar.tintColor = UIColor.fontColor
        
        modeSwitch.isOn = defaults.bool(forKey: "darkModeState")
        alarmSwitch.isOn = defaults.bool(forKey: "alarmState")
        
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
                defaults.set(modeSwitch.isOn, forKey: "darkModeState")
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }

        if alarmSwitch.isOn {
            defaults.set(alarmSwitch.isOn, forKey: "alarmState")
            isAlarmButtonTapped = true
        }

        setState()
        
        print("mode: \(modeSwitch.isOn)")
        print("isAlarm : \(alarmSwitch.isOn)")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    private func setState() {
        if let alarm = defaults.value(forKey: "alarmState"),
           let mode = defaults.value(forKey: "darkModeState") {
            alarmSwitch.isOn = alarm as! Bool
            modeSwitch.isOn = mode as! Bool
        } else {
            alarmSwitch.isOn = false
            modeSwitch.isOn = false
        }
      }
    
    private func setContraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 70),
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
            pickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 350)
        ])
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        createStackView()
    }
    
    private func configureItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "settingButton.svg"),
            style: .done,
            target: self,
            action: #selector(settingButtonTapped)
        )
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
    
    func createStackView() {
        let timerTitle = ["Hours", "Minutes", "Seconds"]
        
        for title in timerTitle {
            let label = UILabel()
            
            label.text = title
            label.textColor = UIColor.fontColor
            label.font = UIFont.Roboto(type: .Regular, size: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            
            stackView.addArrangedSubview(label)
        }
    }
    
    func navigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [.foregroundColor: UIColor.fontColor]
        
        self.navigationItem.title = "타이머"
    }
    
    // MARK: - objc
    
    @objc func startButtonTapped() {
        let vc = UIViewController()
        
        vc.title = "타이머"
        vc.view.backgroundColor = UIColor.init(named: "BGColor")
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = ""
        
        let safeArea = vc.view.safeAreaLayoutGuide
        
        vc.view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            stopButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -70),
            stopButton.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor)
        ])

        vc.view.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            resetButton.trailingAnchor.constraint(equalTo: stopButton.leadingAnchor, constant: -16)
        ])

        vc.view.addSubview(alarmButton)
        NSLayoutConstraint.activate([
            alarmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -72),
            alarmButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor, constant: 16)
        ])

        vc.view.addSubview(shapeView)
        NSLayoutConstraint.activate([
            shapeView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        
        shapeView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor)
        ])
        
        countdownTimer.start()
        updateViews()
        basicAnimation()
        
        if stopButton.currentTitle == "타이머 시작" {
            stopButton.setTitle("타이머 종료", for: .normal)
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
            defaults.set(alarmSwitch.isOn, forKey: "alarmState")
            isAlarmButtonTapped = true
            alarmSwitch.setOn(true, animated: true)
            
            let alert = UIAlertController(title: "알림", message: "알람이 설정되었어요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
            self.present(alert,animated: true,completion: nil)
        } else {
            isAlarmButtonTapped = false
            alarmSwitch.setOn(false, animated: true)
            
            let alert = UIAlertController(title: "알림", message: "알람이 해제되었어요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    @objc func settingButtonTapped() {
        let vc = UIViewController()
        
        vc.title = "설정"
        vc.view.backgroundColor = UIColor.init(named: "BGColor")
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = ""
        
        let safeArea = vc.view.safeAreaLayoutGuide
        
        vc.view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            table.topAnchor.constraint(equalTo: safeArea.topAnchor),
            table.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    @objc func modeSwitchChanged(_ sender: UISwitch) {
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
                defaults.set(modeSwitch.isOn, forKey: "darkModeState")
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    @objc func alarmSwitchChanged(_ sender: UISwitch) {
        if alarmSwitch.isOn {
            defaults.set(alarmSwitch.isOn, forKey: "alarmState")
            isAlarmButtonTapped = true
            print("알람설정 : \(alarmSwitch.isOn)")
        } else {
            isAlarmButtonTapped = false
            print("알람해제 : \(alarmSwitch.isOn)")
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

extension ViewController: CountdownTimerDelegate {
    func timerDidFinish() {
        updateViews()
        stopButton.setTitle("타이머 시작", for: .normal)
        
        if isAlarmButtonTapped == true {
            let alert = UIAlertController(title: "알림", message: "시간이 다됐어요! 🙌🏻", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    func timerDidUpdate(timeRemaining: TimeInterval) {
        updateViews()
    }
}


