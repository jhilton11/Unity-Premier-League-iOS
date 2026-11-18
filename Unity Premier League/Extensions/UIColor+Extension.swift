//
//  UIColor+Extension.swift
//  Unity Premier League
//
//  Created by student on 2025-09-14.
//  Copyright © 2025 Appify Mobile Apps. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func getHexColor(_ color: String) {
        
    }
    
    /// Create UIColor from hex string like "#RRGGBB" or "RRGGBB"
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        guard hexSanitized.count == 6 else { return nil }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
