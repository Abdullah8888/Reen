//
//  Extensions.swift
//  Reen
//
//  Created by Jimoh Babatunde Olalekan on 26/12/2020.
//  Copyright © 2020 Jimoh Babatunde Olalekan. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

extension String {
    //Check if string is only numeric only
    func isValidNumericValueOnly() -> Bool {
        let numberRegEx  = "[0-9]+"
        let testCase = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: self)
    }
}

//MARK: NSNotification Message Identifiers
extension NSNotification.Name {
    static let DidGetTextFromCropping = Notification.Name("DidGetTextFromCropping")
}

