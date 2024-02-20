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
    var title = Constants.Strings.navigationTitleNewGoal
    
    enum FocusedField: CaseIterable {
        case title, aim, currentNumber, step
    }
    
    init(goalID: String?) {
        _viewModel = StateObject(wrappedValue: SettingsViewViewModel(goalID: goalID))
        self._mode = State(initialValue: goalID == nil ? .new : .edit)
        self.title = goalID == nil ? Constants.Strings.navigationTitleNewGoal : Constants.Strings.navigationTitleEditGoal
        self.focusedField = goalID == nil ? .title : nil
    }
    
    @StateObject var viewModel: SettingsViewViewModel
    
    
    @State private var mode: SettingsMode
    
    @FocusState var focusedField: FocusedField?
    
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
        .onAppear {
            if viewModel.goalID == nil {
                focusedField = .title
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(Constants.Strings.confirm) {
                    Task {
                        viewModel.confirm()
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }
                }
            }
            //TODO: Add a toolbarItem, but looks like it doesn't work well with .sheet
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button(focusedField == .step ? Constants.Strings.done : Constants.Strings.nextField) {
                        focusedField = getNextFocusedField()
                    }
                    .padding(.horizontal)
                }
            }
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
                           propertyValueString: $viewModel.goal.title,
                           propertyValueInt: nil,
                           minValue: nil,
                           maxValue: nil)
            .focused($focusedField, equals: .title)
            .onSubmit {
                focusedField = .aim
            }
            .padding(.bottom, 2)
            
            
            Divider()
            
            CustomLineView(propertyName: Text(Constants.Strings.goalAim),
                           propertyValueString: nil,
                           propertyValueInt: $viewModel.goal.aim,
                           minValue: 1,
                           maxValue: 1_000_000)
            .focused($focusedField, equals: .aim)
            .padding(.bottom, 2)
            
            switch mode {
            case .edit:
                Divider()
                CustomLineView(propertyName: Text(Constants.Strings.goalCurrentCount),
                               propertyValueString: nil,
                               propertyValueInt: $viewModel.goal.currentNumber,
                               minValue: 0,
                               maxValue: 1_000_000)
                .focused($focusedField, equals: .currentNumber)
                .padding(.bottom, 2)
                Divider()
            case .new:
                Divider()
            }
            
            CustomLineView(propertyName: Text(Constants.Strings.goalStep),
                           propertyValueString: nil,
                           propertyValueInt: $viewModel.goal.step,
                           minValue: 1,
                           maxValue: 1000)
            .focused($focusedField, equals: .step)
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
            
            ColorPicker(colorString: $viewModel.goal.color)
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
        }
        .onTapGesture {
            focusedField = nil
        }
    }
    
    
    private var buttons: some View {
        HStack(alignment: .center){
            Spacer()
            
            Button("RESET COUNT"){
                feedbackGenerator.impactOccurred()
                viewModel.goal.currentNumber = 0
            }
            .padding(.trailing)
            .buttonStyle(LCButtonStyle(buttonColor: .black))
            
            Button("DELETE GOAL"){
                feedbackGenerator.impactOccurred()
                viewModel.deleteGoal()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(LCButtonStyle(buttonColor: .red))
            Spacer()
        }
    }
    
    
    
    @ViewBuilder
    private var examplesSection: some View {
        ExamplesView() { example in
            viewModel.goal = example
            viewModel.goal.color = example.color
            feedbackGenerator.impactOccurred()
        }
    }
    
    private func getNextFocusedField() -> FocusedField? {
        switch focusedField {
        case .title:
            return .aim
        case .aim:
            return self.mode == .edit ? .currentNumber : .step
        case .currentNumber:
            return .step
        default:
            return nil
        }
    }
    
    private struct Constants {
        
        struct Strings {
            static let backgroundSectionTitle = "Background color"
            static let navigationTitleNewGoal = "New Goal"
            static let navigationTitleEditGoal = "Edit Goal"
            
            static let nextField = "Next"
            static let done = "Done"
            
            static let confirm = "Confirm"
            static let goalTitle = "Title"
            static let goalAim = "Aim"
            static let goalStep = "Step"
            static let goalCurrentCount = "Current count"
            
        }
    }
}




struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(goalID: "")
    }
}
