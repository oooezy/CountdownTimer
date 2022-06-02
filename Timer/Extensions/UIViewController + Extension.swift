//
//  UIViewController + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit

extension UIViewController {
    func presentAlert(message : String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert,animated: true,completion: nil)
      }
}
