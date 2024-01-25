//
//  ExamplesView.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 24.01.2024.
//

import SwiftUI

struct ExamplesView: View, CustomField {
    var onSelectExample: ((Goal) -> Void)?
    
    var body: some View {
        Text("Examples")
            .black18()
            .padding(.leading, 28)
            .textCase(.uppercase)
        
        Rectangle()
            .fill(.white)
            .frame(height: fieldHeight*CGFloat(Constants.goalsExample.count)+3)
            .cornerRadius(10)
            .overlay {
                VStack(spacing: 0) {
                    ForEach(Constants.goalsExample, id: \.id) { item in
                        exampleRow(goal: item)
                            .onTapGesture {
                                if let onSelectExample {
                                    onSelectExample(Goal(title: item.title, aim: item.aim, step: item.step, currentNumber: item.currentNumber, color: item.color))
                                }
                        }
                        Divider()
                    }
                }
            }.padding([.leading, .trailing])
    }
    
    func exampleRow(goal: Goal) -> some View {
        HStack() {
            Text(goal.title)
            Spacer()
            Circle()
                .fill(Color(goal.color))
                .frame(width: Constants.colorButtonHeight, height: Constants.colorButtonHeight)
        }
        .padding([.leading, .trailing])
        .frame(height: fieldHeight)
        .contentShape(Rectangle())
    }
    
    private struct Constants {
        static let colorButtonHeight = 30.0
        static let goalsExample = [Goal(title: "Drink 8 Glasses of Water", aim: 8, step: 1, currentNumber: 0, color: "CustomRed"),
                                   Goal(title: "Visit 5 New Countries", aim: 5, step: 1, currentNumber: 0, color: "CustomBlueDodger"),
                                   Goal(title: "5 books read", aim: 5, step: 1, currentNumber: 0, color: "CustomYellow"),
                                   Goal(title: "Save $1000", aim: 1000, step: 10, currentNumber: 0, color: "CustomBlueAqua"),
                                   Goal(title: "10 gym visits", aim: 10, step: 1, currentNumber: 0, color: "CustomPink")]
    }
}

#Preview {
    ExamplesView()
}
