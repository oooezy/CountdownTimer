//
//  UIButton + Extension.swift
//  Timer
//
//  Created by 이은지 on 2022/06/03.
//

import UIKit

extension UIButton {
    func setStateButtonUI(buttonTitle: String) {
        let button = self
        button.setTitle(buttonTitle, for: .normal)
        button.backgroundColor = .mainColor
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 54, bottom: 15, right: 54)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.mainColor.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.shadowRadius = 8
    }
    
    func setCircleButtonUI(image: String) {
        let button = self
        button.setImage(UIImage(named: "\(image).png"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.shadowColor = UIColor.mainColor.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 4
    }
}
