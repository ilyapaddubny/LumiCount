//
//  CustomFormLineView.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 19.08.2023.
//

import SwiftUI
import Combine



struct CustomLineView: View, CustomField {
    
    var body: some View {
        if let propertyValue = propertyValueString {
            HStack {
                propertyName.black18()
                Spacer()
                TextField(Constants.Strings.enterValue, text: Binding(
                    get: {
                        propertyValue.wrappedValue
                    }, set: { newValue in
//                        propertyValue.wrappedValue = newValue
                        propertyValue.wrappedValue = (newValue.trimmingCharacters(in: [" "]).isEmpty ? "New goal" : newValue)
                    }
                ))
//                .selectAllTextOnFocus(true)
                    .rightAlignment()
                    .frame(minHeight: fieldHeight)
            }
            .frame(height: Constants.fieldHeight)
        }
        if let propertyValue = propertyValueInt {
            HStack{
                propertyName.black18()
                Spacer()
                TextField(Constants.Strings.enterValue, value: Binding(
                    get: { propertyValue.wrappedValue },
                    set: { newValue in
                        propertyValue.wrappedValue = min(max(newValue, minValue ?? 1), maxValue ?? 100_000)
                    }
                ), formatter: NumberFormatter())
                .rightAlignment()
                .frame(minHeight: fieldHeight)
                .keyboardType(.numberPad)
            }.frame(height: Constants.fieldHeight)
            
        }
    }
    
    let propertyName: Text
    let propertyValueString: Binding<String>?
    let propertyValueInt: Binding<Int>?
    let minValue: Int?
    let maxValue: Int?
    
    private struct Constants {
        static let fieldHeight = 43.0
        struct Strings {
            static let enterValue = "Enter value"
        }
    }
    
}

struct TestNewGoal_Previews: PreviewProvider {
    static var previews: some View {
        CustomLineView(propertyName: Text("Title"), propertyValueString: nil, propertyValueInt: nil, minValue: nil, maxValue: nil).padding(.bottom, 2)
    }
}
