//
//  CustomFormLineView.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 19.08.2023.
//

import SwiftUI



struct CustomLineView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            if let propertyValue = propertyValueString {
                HStack {
                    propertyName.black18()
                    Spacer()
                    TextField(Constants.Strings.enterValue, text: propertyValue)
                        .rightAlignment()
                }
                .frame(height: Constants.fieldHeight)
            }
            if let propertyValue = propertyValueInt {
                HStack{
                    propertyName.black18()
                    Spacer()
                    TextField(Constants.Strings.enterValue, value: propertyValue, formatter: NumberFormatter())
                        .rightAlignment()
                        .keyboardType(.numberPad)
                }.frame(height: Constants.fieldHeight)
            }
            
            if errorAlert {
                HStack {
                    Text(errorText)
                        .redRegular(size: Constants.alirtTextSize)
                    Spacer()
                }
                .frame(height: Constants.alirtFrameHeight)
            }
        }
    }
        
    let propertyName: Text
    let propertyValueString: Binding<String>?
    let propertyValueInt: Binding<Int>?
    let errorAlert: Bool
    let errorText: String
    
    private struct Constants {
        static let fieldHeight = 43.0
        static let alirtTextSize = 14.0
        static let alirtFrameHeight = 8.0
        struct Strings {
            static let enterValue = "Enter value"
        }
    }
    
}

struct TestNewGoal_Previews: PreviewProvider {
    static var previews: some View {
        CustomLineView(propertyName: Text("Title"), propertyValueString: nil, propertyValueInt: nil, errorAlert: true, errorText: "Field can't be empty").padding(.bottom, 2)
    }
}
