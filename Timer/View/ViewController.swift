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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    lazy var minutesLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Minutes"
        label.textColor = fontColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()

    lazy var secondsLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Seconds"
        label.textColor = fontColor
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
    
    lazy var button: UIButton = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = lightBGColor
        UINavigationBar()
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
        print(hours.count)

        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }

    func UINavigationBar() {
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
        setTime.font = UIFont.systemFont(ofSize: 40, weight: .light)
        
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
