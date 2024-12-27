//
//  UIColor+Extensions.swift
//  BabyMoment
//
//  Created by July universe on 10/28/24.
//

import SwiftUI

extension UIColor {
    func darker(by percentage: CGFloat = 5.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    func lighter(by percentage: CGFloat = 5.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 5.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(max(red + percentage / 100, 0.0), 1.0),
                           green: min(max(green + percentage / 100, 0.0), 1.0),
                           blue: min(max(blue + percentage / 100, 0.0), 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    func brightness() -> CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            // 간단한 밝기 계산: RGB의 평균
            return (red + green + blue) / 3
        }
        return 0
    }
}
