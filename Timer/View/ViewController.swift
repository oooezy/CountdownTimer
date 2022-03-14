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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.UINavigationBar()
        self.view.backgroundColor = lightBGColor
    }

    func UINavigationBar() {
        let navBar = self.navigationController!.navigationBar
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        navBar.titleTextAttributes = [.foregroundColor: fontColor]
        
        self.navigationItem.title = "타이머"
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
