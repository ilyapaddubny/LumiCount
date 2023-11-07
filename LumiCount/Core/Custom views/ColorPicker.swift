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
            //TODO: Medium padding is not constan when color picked
            colorHStack(colors: Array(customColors.prefix(5)))
                .padding(.bottom, Constants.spaceBetweenColorHstacks)
            colorHStack(colors: Array(customColors.dropFirst(5)))
        }
        .padding([.top, .bottom], Constants.sectionPadding)
        .background(Color.white)
        .cornerRadius(Constants.sectionCornerRadius)
    }
    
    private func colorHStack(colors: [Color]) -> some View  {
        HStack() {
            ForEach(colors, id: \.self) { color in
                Spacer()
                colorButton(color)
            }
            Spacer()
        }
    }
    
    private func colorButton(_ color: Color) -> some View {
        Button(action: {
            selectedColor = color
        }) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: Constants.colorButtonHeight, height: Constants.colorButtonHeight)
                if selectedColor == color {
                    Image(systemName: Constants.selectorImageName)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    let customColors: [Color] = [.customRed, .customBlueAqua, .customGray, .customPink, .customGreenEmerald,
                                 .customOrange, .customPurple, .customYellow, .customBlueDodger, .customGreenShamrock]
    
    private func forEachInRange<T>(_ range: Range<Int>, action: (Int) -> T) -> [T] {
        return range.map { index in
            return action(index)
        }
    }
    
    private struct Constants {
        static let sectionPadding = 15.0
        static let spaceBetweenColorHstacks = 15.0
        static let sectionCornerRadius = 10.0
        static let colorButtonHeight = 30.0
        static let selectorImageName = "checkmark.circle.fill"
    }
}


struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(selectedColor: .constant(Color.black))
    }
}
