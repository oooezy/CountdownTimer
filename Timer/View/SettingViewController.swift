//
//  SettingViewController.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit

class SettingViewController: UIViewController {
    
    let settingList: [String] = ["다크모드 설정", "알람 설정"]
    let etcList: [String] = ["버전"]
    
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
        modeSwitch.setSwitchUI()
        modeSwitch.addTarget(self, action: #selector(modeSwitchChanged(_:)), for: .valueChanged)
        
        return modeSwitch
    }()
    
    lazy var alarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch(frame: .zero)
        alarmSwitch.setSwitchUI()
        alarmSwitch.addTarget(self, action: #selector(alarmSwitchChanged(_:)), for: .valueChanged)
        
        return alarmSwitch
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "설정"
        self.view.backgroundColor = UIColor.init(named: "BGColor")
        
        table.delegate = self
        table.dataSource = self
        
        setState()
        setContraints()
    }
    
    // MARK: - Private
    private func setContraints() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(table)
        NSLayoutConstraint.activate([
            table.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            table.topAnchor.constraint(equalTo: safeArea.topAnchor),
            table.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
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
    
    // MARK: - objc
    @objc func modeSwitchChanged(_ sender: UISwitch) {
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
                defaults.set(modeSwitch.isOn, forKey: "darkModeState")
            } else {
                window.overrideUserInterfaceStyle = .light
                defaults.set(false, forKey: "darkModeState")
            }
        }
    }
    
    @objc func alarmSwitchChanged(_ sender: UISwitch) {
        if alarmSwitch.isOn {
            isAlarmButtonTapped = true
            defaults.set(alarmSwitch.isOn, forKey: "alarmState")
        } else {
            isAlarmButtonTapped = false
            defaults.set(false, forKey: "alarmState")
        }
    }
}

// MARK: - Extension
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0 :
                return settingList.count
            case 1:
                return etcList.count
            default :
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0 :
                return "설정"
            case 1:
                return "기타"
            default :
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let tableView = view as? UITableViewHeaderFooterView else { return }
        tableView.textLabel?.textColor = UIColor.fontColor
        tableView.textLabel?.font = UIFont.Roboto(type: .Medium, size: 14)
        tableView.contentView.backgroundColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor(hex: 0x313233)
            default:
                return UIColor(hex: 0xF2F2F2)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let text: String = indexPath.section == 0 ? settingList[indexPath.row] : etcList[indexPath.row]
        cell.textLabel?.setLabelUI(text: text, type: .Regular, size: 16)
        cell.backgroundColor = UIColor.init(named: "BGColor")
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let versionLabel = UILabel()
        versionLabel.setLabelUI(text: version, type: .Regular, size: 16)
        versionLabel.sizeToFit()
        
        if indexPath[0] == 0 && indexPath[1] == 0 {
            cell.accessoryView = modeSwitch
        } else if indexPath[0] == 0 && indexPath[1] == 1 {
            cell.accessoryView = alarmSwitch
        } else {
            cell.accessoryView = versionLabel
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
