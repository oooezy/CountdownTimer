import UIKit
import RxCocoa
import RxSwift

var defaults = UserDefaults.standard
var isAlarmButtonTapped: Bool = false

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    var disposeBag: DisposeBag = DisposeBag()

    let timerVC = TimerViewController()
    let settingVC = SettingViewController()
    
    // MARK: - UI
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let line: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "line.svg")
        imageView.image = image
        return imageView
    }()
 
    private lazy var  startButton: UIButton = {
        let startButton = UIButton()
        startButton.setStateButtonUI(buttonTitle: "타이머 시작")
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return startButton
    }()
    
    private let pickerView = UIPickerView()

    // MARK: - Properties
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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(named: "BGColor")
        
        configureNavigation()
        setContraints()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.selectRow(0, inComponent: 2, animated: false)
        pickerView.selectRow(30, inComponent: 4, animated: false)
        
        settingVC.modeSwitch.isOn = defaults.bool(forKey: "darkModeState")
        settingVC.alarmSwitch.isOn = defaults.bool(forKey: "alarmState")
        
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = settingVC.modeSwitch.isOn == true ? .dark : .light
                defaults.set(settingVC.modeSwitch.isOn, forKey: "darkModeState")
            } else {
                window.overrideUserInterfaceStyle = .light
                defaults.set(false, forKey: "darkModeState")
            }
        }

        if settingVC.alarmSwitch.isOn {
            defaults.set(settingVC.alarmSwitch.isOn, forKey: "alarmState")
            isAlarmButtonTapped = true
        }
    }
    
    // MARK: - Private
    private func setContraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        [stackView, line, startButton, pickerView].forEach({view.addSubview($0)})
        [stackView, line, pickerView].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 70),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            line.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            line.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            line.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -70),
            startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])

        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            pickerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        createStackView()
    }
    
    private func createStackView() {
        let timerTitle = ["Hours", "Minutes", "Seconds"]
        
        for title in timerTitle {
            let label = UILabel()
            label.setLabelUI(text: title, type: .Regular, size: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            
            stackView.addArrangedSubview(label)
        }
    }
    
    private func configureNavigation() {
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [.foregroundColor: UIColor.fontColor]
        navBar.tintColor = UIColor.fontColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem (
            image: UIImage(named: "settingButton.svg"),
            style: .done,
            target: self,
            action: #selector(settingButtonTapped)
        )
    }
    
    // MARK: - objc
    @objc func startButtonTapped() {
        let vc = TimerViewController()
        vc.duration = duration
        
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = ""
    }
    
    @objc func settingButtonTapped() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = ""
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 88
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return view.frame.width / 6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData[component].count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let timeValue = String(pickerViewData[component][row])
        
        let pickerLabel = UILabel()
        pickerLabel.text = timeValue
        pickerLabel.textColor = (row == pickerView.selectedRow(inComponent: component)) ? .mainColor : .fontColor
        pickerLabel.textAlignment = .center
        pickerLabel.font = UIFont.Roboto(type: .Light, size: 38)

        return pickerLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(component)
        viewModel.duration = duration
    }
}
