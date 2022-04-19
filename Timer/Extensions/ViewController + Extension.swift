//
//  UIViewController + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/03/16.
//

import UIKit

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
        countdownTimer.duration = duration
        updateViews()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        tableView.textLabel?.font = UIFont.Roboto(type: .Medium, size: 18)
        tableView.contentView.backgroundColor = UIColor(hex: 0xF2F2F2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let text: String = indexPath.section == 0 ? settingList[indexPath.row] : etcList[indexPath.row]
        cell.textLabel?.text = text
        cell.textLabel?.font = UIFont.Roboto(type: .Regular, size: 16)
        cell.textLabel?.textColor = UIColor.fontColor
        
        cell.layer.addBorder([.bottom], color: UIColor(hex: 0xECECEC), width: 1.0)
        cell.layer.addBorder([.top], color: .white, width: 1.0)
        
        //here is programatically switch make to the table view
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = .mainColor
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        if indexPath[0] == 0 {
            cell.accessoryView = switchView
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }

}
