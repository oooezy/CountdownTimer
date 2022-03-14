//
//  ViewController.swift
//  Timer
//
//  Created by 이은지 on 2022/03/14.
//

import UIKit

class ViewController: UIViewController {

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
        let startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 160, height: 48))
        
        startButton.backgroundColor = mainColor
        startButton.setTitle("시작", for: .normal)
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        
        return startButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = lightBGColor
        UINavigationBar()
        
        view.addSubview(stackView)
        [hoursLabel, minutesLabel, secondsLabel].map {
            stackView.addArrangedSubview($0)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        let constraints = [
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 64),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        view.addSubview(button)
        button.center = view.center
    }

    func UINavigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [.foregroundColor: fontColor]
        
        self.navigationItem.title = "타이머"
    }
    
    @objc func didTapStartButton() {
        let vc = UIViewController()
        vc.title = "타이머"
        vc.view.backgroundColor = lightBGColor
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.navigationBar.tintColor = fontColor
        navigationItem.backButtonTitle = ""
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
