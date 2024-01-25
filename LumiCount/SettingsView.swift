//
//  SettingsView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import SwiftUI
import UIKit

enum SettingsMode {
    case new, edit
}

struct SettingsView: View, CustomField {
    
    enum Focused {
        case title, aim, step, currentNumber
    }
    
    @Binding var goal: Goal
    let mode: SettingsMode
    @FocusState var focused: Focused?
    
    let deleteAction: (String) -> Void
    
    @Environment(\.presentationMode) var presentationMode
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            LinearGradient (
                gradient: Gradient(colors: [Color.backgroundTop, Color.backgroundBottom]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading){
                    goalSection
                    colorPickerSection
                    switch mode {
                    case .new:
                        examplesSection
                    case .edit:
                        buttons
                            .padding(.top, 70)
                    }
                    
                    Spacer(minLength: 0.0)
                }
            }
        }
//        .toolbar(content: {
//            toolbarItem
//        })
        .onAppear {
            if goal.title.isEmpty {
                focused = .title
            }
        }
    }
    
    private var toolbarItem: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                Spacer()
                Button("Done") {
                    print("do something")
                }
                .padding(.horizontal)
            }
            .zIndex(100)
        }
    }
    
    private var goalSection: some View {
        Group {
            Text("Goal properties")
                .black18()
                .padding(.leading, 28)
                .textCase(.uppercase)
                .padding(.top, 20)
            Rectangle()
                .fill(.white)
                .overlay{
                    propertyView
                }
                .cornerRadius(10)
                .frame(height: mode == SettingsMode.edit ?  186 : 140) //bad design, had a problem with compelation
//            (fieldHeight * 4) + (1 * 3) + 3 + (4 * 2) : (fieldHeight * 3) + (1 * 2) + 3 + (3 * 2) - number of fields + number of deviders + 3pt to look nicer
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
        }
    }
    
    @ViewBuilder
    private var propertyView: some View {
        VStack(spacing: 0) {
            CustomLineView(propertyName: Text(Constants.Strings.goalTitle),
                           propertyValueString: $goal.title,
                           propertyValueInt: nil,
                           minValue: nil,
                           maxValue: nil)
            .focused($focused, equals: .title)
            .onSubmit {
                focused = .aim
            }
            .padding(.bottom, 2)
            
            
            Divider()
            
            CustomLineView(propertyName: Text(Constants.Strings.goalAim),
                           propertyValueString: nil,
                           propertyValueInt: $goal.aim,
                           minValue: 1,
                           maxValue: 1_000_000)
            .focused($focused, equals: .aim)
            .padding(.bottom, 2)
            
            switch mode {
            case .edit:
                Divider()
                CustomLineView(propertyName: Text(Constants.Strings.goalCurrentCount),
                               propertyValueString: nil,
                               propertyValueInt: $goal.currentNumber,
                               minValue: 0,
                               maxValue: 1_000_000)
                .focused($focused, equals: .currentNumber)
                .padding(.bottom, 2)
                Divider()
            case .new:
                Divider()
            }
            
            CustomLineView(propertyName: Text(Constants.Strings.goalStep),
                           propertyValueString: nil,
                           propertyValueInt: $goal.step,
                           minValue: 1,
                           maxValue: 1000)
            .focused($focused, equals: .step)
            .padding(.bottom, 2)
        }
        .padding(.top, 3)
        .padding(.leading)
    }
    
    private var colorPickerSection: some View {
        Group {
            Text("Background color")
                .black18()
                .padding(.leading, 28)
                .textCase(.uppercase)
            
            ColorPicker(colorString: $goal.color)
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
        }
    }
    
    private var buttons: some View {
        HStack(alignment: .center){
            Spacer()
            
            Button("RESET COUNT"){
                feedbackGenerator.impactOccurred()
                goal.currentNumber = 0
            }
            .padding(.trailing)
            .buttonStyle(LCButtonStyle(buttonColor: .black))
            
            Button("DELETE GOAL"){
                feedbackGenerator.impactOccurred()
                deleteAction(goal.id)
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(LCButtonStyle(buttonColor: .red))
            Spacer()
        }
    }
    
    
    
    @ViewBuilder
    private var examplesSection: some View {
        ExamplesView() { example in
            goal = example
            feedbackGenerator.impactOccurred()
        }
    }
    
    private struct Constants {
        
        struct Strings {
            static let backgroundSectionTitle = "Background color"
            static let navigationTitle = "Edit Goal"
            
            static let goalTitle = "Title"
            static let goalAim = "Aim"
            static let goalStep = "Step"
            static let goalCurrentCount = "Current count"
            
        }
    }
}




struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let goal = Goal(title: "Gym visits", aim: 10, step: 1, currentNumber: 1, color: "")
        SettingsView(goal: .constant(goal), 
                     mode: .edit,
                     deleteAction: {_ in })
    }
}
