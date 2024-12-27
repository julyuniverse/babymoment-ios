//
//  Color+Extensions.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import SwiftUI

extension Color {
    func darker() -> Color {
        let uiColor = UIColor(self)
        let brightness = uiColor.brightness()
        
        // 밝기가 낮을 경우 (이미 어두운 색상일 경우) 밝기를 높임
        if brightness < 0.2 {
            return Color(uiColor.lighter(by: 5) ?? uiColor)
        } else {
            return Color(uiColor.darker(by: 5) ?? uiColor)
        }
    }
}
