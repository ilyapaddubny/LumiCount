//
//  CustomFormLineView.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 19.08.2023.
//

import SwiftUI



struct CustomLineView: View {
    
    let propertyName: Text
    let propertyValueString: Binding<String>?
    let propertyValueInt: Binding<Int>?
    let errorAlert: Bool
    let errorText: String
    
    var body: some View {
        VStack(spacing: 0) {
            if let propertyValue = propertyValueString {
                HStack {
                    propertyName.black18()
                    Spacer()
                    TextField("Enter value", text: propertyValue)
                        .rightAlignment()
                }
                .frame(height: 43)
            }
            if let propertyValue = propertyValueInt {
                HStack{
                    propertyName.black18()
                    Spacer()
                    TextField("Enter value", value: propertyValue, formatter: NumberFormatter())
                        .rightAlignment()
                        .keyboardType(.numberPad)
                }.frame(height: 43)
            }
            
            if errorAlert {
                    HStack {
                        Text(errorText)
                            .redRegular(size: 14)
                        Spacer()
                    }
                    .frame(height: 8)
            }
        }
    }
    
}

struct TestNewGoal_Previews: PreviewProvider {
    static var previews: some View {
        CustomLineView(propertyName: Text("Title"), propertyValueString: nil, propertyValueInt: nil, errorAlert: true, errorText: "Field can't be empty").padding(.bottom, 2)
    }
}
