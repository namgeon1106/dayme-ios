//
//  UIColor++.swift
//  Dayme
//
//  Created by 정동천 on 11/27/24.
//

import UIKit

extension UIColor {
    
    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

extension CGColor {
    
    static func uiColor(_ color: UIColor) -> CGColor {
        color.cgColor
    }
    
    static func hex(_ hex: String, alpha: CGFloat = 1.0) -> CGColor {
        uiColor(.hex(hex, alpha: alpha))
    }
    
}
