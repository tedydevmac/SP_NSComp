//
//  Hex2Color.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        let hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        
        // Ensure the string is valid
        var hexInt: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&hexInt)
        
        let red = Double((hexInt >> 16) & 0xFF) / 255.0
        let green = Double((hexInt >> 8) & 0xFF) / 255.0
        let blue = Double(hexInt & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
extension UIColor {
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        // Ensure the hex string is exactly 6 characters
        guard hexFormatted.count == 6 else {
            // Provide a default color (e.g., clear) if the hex string is invalid
            self.init(white: 0.0, alpha: 0.0)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
