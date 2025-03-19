//
//  Hex2Color.swift
//  SP_NSC
//
//  Created by Ted Goh on 19/3/25.
//

import SwiftUI

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
