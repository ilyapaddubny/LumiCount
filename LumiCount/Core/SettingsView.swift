//
//  SettingsView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    
    @StateObject var viewModel: SettingsViewViewModel
    
    @Environment(\.presentationMode) var presentationMode
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    init(goal: Goal) {
        _viewModel = StateObject(wrappedValue: SettingsViewViewModel(goal: goal))
        
        //Use this if NavigationBarTitle is with displayMode = .inline (https://stackoverflow.com/questions/56505528/swiftui-update-navigation-bar-title-color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Color.black]
    }
    
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
                    buttons
                    .padding(.top, 70)
                    
                    Spacer(minLength: 0.0)
                }
            }
        }
        .alert(isPresented: $viewModel.alert) {
            Alert( //TODO: deprecated
                title: Text(Constants.Strings.alertTitle),
                message: Text(viewModel.alertDescription),
                dismissButton: .default(Text(Constants.Strings.alertDismissButton)) {
                    viewModel.alertDescription = ""
                }
            )
        }
        .navigationTitle(Constants.Strings.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar) //hides the tabBar
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(Constants.Strings.confirm) {
                    Task {
                        guard viewModel.validateFields() else {
                            return
                        }
                        await viewModel.updateGoal()
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                        
                    }
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
                .overlay(propertyView)
                .cornerRadius(10)
                .frame(height: viewModel.propertiesHeight)
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
        }
    }
    
    private var colorPickerSection: some View {
        Group {
            Text("Background color")
                .black18()
                .padding(.leading, 28)
                .textCase(.uppercase)
            
            ColorPicker(selectedColor: $viewModel.color)
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
        }
    }
    
    private var buttons: some View {
        HStack(alignment: .center){
            Spacer()
            
            Button("RESET COUNT"){
                //                      actions on Reset button
                feedbackGenerator.impactOccurred()
                viewModel.resetCount()
            }
            .padding(.trailing)
            .buttonStyle(TintedButtonStyle(buttonColor: .black))
            
            Button("DELETE GOAL"){
                feedbackGenerator.impactOccurred()
                Task {
                    await viewModel.deleteGoal()
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }
            }
            .buttonStyle(TintedButtonStyle(buttonColor: .red))
            Spacer()
        }
    }
    
    private var propertyView: some View {
        
        VStack(spacing: 0) {
            
            CustomLineView(propertyName: Text(Constants.Strings.goalTitle),
                           propertyValueString: $viewModel.goal.title,
                           propertyValueInt: nil,
                           errorAlert: viewModel.titleAlertPresense,
                           errorText: Constants.Strings.goalTitleError)
            .padding(.bottom, 2)
            
            Divider()
            
            CustomLineView(propertyName: Text(Constants.Strings.goalAim),
                           propertyValueString: nil,
                           propertyValueInt: $viewModel.goal.aim,
                           errorAlert: viewModel.aimAlertPresense,
                           errorText: Constants.Strings.goalAimError)
            .padding(.bottom, 2)
            
            Divider()
            
            CustomLineView(propertyName: Text(Constants.Strings.goalCurrentCount),
                           propertyValueString: nil,
                           propertyValueInt: $viewModel.goal.currentNumber,
                           errorAlert: viewModel.currentCountAlertPresense,
                           errorText: Constants.Strings.goalCurrentCountError)
            .padding(.bottom, 2)
            
            Divider()
            
            CustomLineView(propertyName: Text(Constants.Strings.goalStep),
                           propertyValueString: nil,
                           propertyValueInt: $viewModel.goal.step,
                           errorAlert: viewModel.stepAlertPresense,
                           errorText: Constants.Strings.goalStepError)
            .padding(.bottom, 2)
            
        }
        .padding(.top, 3)
        .padding(.leading)
    }
    
    private struct Constants {
        
        struct Strings {
            static let backgroundSectionTitle = "Background color"
            static let confirm = "Confirm"
            static let navigationTitle = "Edit Goal"
            
            static let alertTitle = "Error"
            static let alertDismissButton = "OK"
            
            static let goalTitle = "Title"
            static let goalTitleError = "Field can't be empty"
            static let goalAim = "Aim"
            static let goalAimError = "Value can't be 0 or over 1 million"
            static let goalStep = "Step"
            static let goalStepError = "Value can't be 0 or over 999"
            static let goalCurrentCount = "Current count"
            static let goalCurrentCountError = "Value is too large. It can't be over 1 million."
            
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(goal: Goal(id: UUID(), title: "Gym visits", aim: 10, step: 1, currentNumber: 1, color: "", arrayIndex: 0))
    }
}
