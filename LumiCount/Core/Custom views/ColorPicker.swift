//
//  ColorPicker.swift
//  CountMate
//
//  Created by Ilya Paddubny on 05.06.2023.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack {
            HStack() {
                ForEach(customColors.prefix(5), id: \.self) { color in
                    Spacer()
                    colorButton(color)
                }
                Spacer()
            }.padding(.top, 15)
                .padding(.bottom, 6)
            HStack() {
                ForEach(customColors.dropFirst(5), id: \.self) { color in
                    Spacer()
                    colorButton(color)
                }
                Spacer()
            }.padding(.bottom, 15)
                .padding(.top, 6)
        }
            .background(Color.white)
            .cornerRadius(10)
    }
    
    private func colorButton(_ color: Color) -> some View {
        Button(action: {
            selectedColor = color
        }) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 30, height: 30)
                if selectedColor == color {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    let customColors: [Color] = [.customRed, .customBlueAqua, .customGray, .customPink, .customGreenEmerald,
                                 .customOrange, .customPurple, .customYellow, .customBlueDodger, .customGreenShamrock]
}


struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(selectedColor: .constant(Color.black))
    }
}
