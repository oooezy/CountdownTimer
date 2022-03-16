//
//  UIViewController + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/03/16.
//

import UIKit

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
            return 24
        case 1, 3:
            return 1;
        case 2, 4:
            return 60
        default:
            return 1;
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let setTime = UILabel(frame: CGRect(x: 0, y: 0, width: 54, height: 56))
        setTime.text = {
            switch (component) {
            case 0:
                return row < 10 ? "0\(row)" : "\(row)"
            case 2, 4:
                return row < 10 ? "0\(row)" : "\(row)"
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
