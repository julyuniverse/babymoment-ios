//
//  CustomButtonView.swift
//  BabyMoment
//
//  Created by July universe on 10/27/24.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .background(configuration.isPressed ? color.darker() : color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
//            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
//            .animation(.easeIn(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { isPressed in
                            if isPressed {
                                // 눌렸을 때 약간의 딜레이 후에 작아지게 설정
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        configuration.label.scaleEffect(0.95)
                                    }
                                }
                            } else {
                                // 눌림이 해제되면 원래 크기로 복원
                                withAnimation(.easeOut(duration: 0.2)) {
                                    configuration.label.scaleEffect(1.0)
                                }
                            }
                        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Button("Click Me") {}
        .buttonStyle(CustomButtonStyle(color: .yellow))
}
