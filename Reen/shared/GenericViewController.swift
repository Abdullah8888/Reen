//
//  GenericViewController.swift
//  Reen
//
//  Created by Jimoh Babatunde Olalekan on 26/12/2020.
//  Copyright © 2020 Jimoh Babatunde Olalekan. All rights reserved.
//

import Foundation
import  UIKit
import RKDropdownAlert

enum NavigationBarUIState {
    case withBackText
    case withEmpty
}

class GenericViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setNavigationBar(state: NavigationBarUIState) {
        switch state {
        case .withBackText:
            self.showNavigationBar(isWithBackText: true, isWithEmpty: false)
        case .withEmpty:
            self.showNavigationBar(isWithBackText: false, isWithEmpty: true)
        }
    }
    
    func showNavigationBar(isWithBackText: Bool, isWithEmpty: Bool) {
        self.navigationItem.setLeftBarButtonItems(nil, animated: false)
        self.navigationItem.setRightBarButtonItems(nil, animated: false)
//        let navigationBarHeight = UIApplication.shared.statusBarFrame.size.height +
//        (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "E5E5E5")
        if !isWithBackText && isWithEmpty {
            print("here")
            //self.navigationController?.view.addSubview(parenetView)
            
        }
        else if isWithBackText && !isWithEmpty {
            let leftText = UILabel(frame: CGRect(x: 0, y: 5, width: 30, height: 30))
            leftText.text = "Back"
            leftText.isUserInteractionEnabled = true
            let tapLeftText = UITapGestureRecognizer(target: self, action: #selector(self.goBack))
            leftText.addGestureRecognizer(tapLeftText)
            let navItem = UIBarButtonItem.init(customView: leftText)
            self.navigationItem.setLeftBarButtonItems([navItem], animated: true)
            
        }
    }
    
    @objc func goBack () {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func displayDropDownAlertWithTitle(title: String, message: String, error: Bool) {
        RKDropdownAlert.title(title, message: message, backgroundColor: error ? UIColor.init(hex: "f05858") : UIColor.init(hex: "66bb6a"), textColor: UIColor.white, time: 2)
    }
}
