//
//  CMTintedButton.swift
//  CountMate
//
//  Created by Ilya Paddubny on 06.06.2023.
//

import SwiftUI

struct LCButtonStyle: ButtonStyle {
    var buttonColor: Color

       func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .padding([.top, .bottom], 15)
               .frame(width: 150.0)
               .foregroundColor(buttonColor)
               .background(configuration.isPressed ? .white.opacity(0.8) : .white.opacity(1))
               .cornerRadius(10)
               .overlay(RoundedRectangle(cornerRadius: 10).stroke(.white.opacity(1), lineWidth: 1))
       }
}


