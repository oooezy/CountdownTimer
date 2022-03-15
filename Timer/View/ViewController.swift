//
//  ViewController.swift
//  Timer
//
//  Created by 이은지 on 2022/03/14.
//

import UIKit

class ViewController: UIViewController {
    private let pickerView = UIPickerView()
    
    var hours: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    var minSec: [String] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]

    let fontColor = UIColor(rgb: 0xA3A3A3)
    let mainColor = UIColor(rgb: 0xE06565)
    let lightBGColor = UIColor(rgb: 0xFAFAFA)
    let darkBGColor = UIColor(rgb: 0x252628)
    
    lazy var hoursLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Hours"
        label.textColor = fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    lazy var minutesLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Minutes"
        label.textColor = fontColor
        label.font = UIFont.Roboto(type: .Regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    lazy var secondsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Seconds"
        label.textColor = fontColor
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
        
        startButton.backgroundColor = mainColor
        startButton.setTitle("시작", for: .normal)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        startButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 64, bottom: 15, right: 64)
        startButton.layer.cornerRadius = 25
        startButton.layer.shadowColor = mainColor.cgColor
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        startButton.layer.shadowRadius = 8
        
    
        return startButton
    }()
    
    lazy var stopButton: UIButton = {
        let stopButton = UIButton()
        
        stopButton.backgroundColor = mainColor
        stopButton.setTitle("일시정지", for: .normal)
        stopButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        stopButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 64, bottom: 15, right: 64)
        stopButton.layer.cornerRadius = 25
        stopButton.layer.shadowColor = mainColor.cgColor
        stopButton.layer.shadowOpacity = 0.3
        stopButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        stopButton.layer.shadowRadius = 8
        
    
        return stopButton
    }()
    
    lazy var resetButton: UIButton = {
        let resetButton = UIButton()
        
        resetButton.setImage(UIImage(named: "resetButton.png"), for: .normal)
        resetButton.layer.shadowColor = mainColor.cgColor
        resetButton.layer.shadowOpacity = 0.3
        resetButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        resetButton.layer.shadowRadius = 8
        
        return resetButton
    }()
    
    lazy var alarmButton: UIButton = {
        let alarmButton = UIButton()
        
        alarmButton.setImage(UIImage(named: "alarmButton.png"), for: .normal)
        alarmButton.layer.shadowColor = mainColor.cgColor
        alarmButton.layer.shadowOpacity = 0.3
        alarmButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        alarmButton.layer.shadowRadius = 8
        
        return alarmButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = lightBGColor
        navigationBar()
//        setAttributes()
        setContraints()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
//    private func setAttributes() {
//        pickerView.datePickerMode = .countDownTimer
//        pickerView.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
//    }

    private func setContraints() {
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.setValue(mainColor, forKey: "textColor")

        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        [hoursLabel, minutesLabel, secondsLabel].map {
            stackView.addArrangedSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        let constraints = [
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    func navigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [.foregroundColor: fontColor]
        
        self.navigationItem.title = "타이머"
    }
    
    // MARK: - Selectors
    @objc func didTapStartButton() {
        let vc = UIViewController()
        vc.title = "타이머"
        vc.view.backgroundColor = lightBGColor
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.navigationBar.tintColor = fontColor
        navigationItem.backButtonTitle = ""
        
        vc.view.addSubview(stopButton)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -150).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        
        vc.view.addSubview(resetButton)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -150).isActive = true
        resetButton.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 30).isActive = true
        
        vc.view.addSubview(alarmButton)
        alarmButton.translatesAutoresizingMaskIntoConstraints = false
        alarmButton.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -150).isActive = true
        alarmButton.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor, constant: -30).isActive = true
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
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch (component) {
//        case 0, 2, 4:
//            return String(row)
//        case 1, 3:
//            return ":"
//        default:
//            return ""
//        }
//    }

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
        setTime.textColor = (row == pickerView.selectedRow(inComponent: component)) ? mainColor : fontColor
        setTime.textAlignment = .center
        setTime.font = UIFont.Roboto(type: .Light, size: 40)
        
        return setTime
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            pickerView.reloadComponent(component)
    }
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIFont {
    class func Roboto(type: RobotoType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }

    public enum RobotoType {
        case Light
        case Medium
        case Regular
        
        var name: String {
            switch self {
            case .Light:
                return "Roboto-Light"
            case .Medium:
                return "Roboto-Medium"
            case .Regular:
                return "Roboto-Regular"
            }
        }
    }
}
