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
                    //                goal properties section
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
                    
                    //                    color picker section
                    Text("Background color")
                        .black18()
                        .padding(.leading, 28)
                        .textCase(.uppercase)
                    
                    //                    ColorPicker(selectedColor: $goal.color)
                    ColorPicker(selectedColor: $viewModel.color)
                        .padding([.leading, .trailing])
                        .padding(.bottom, 10)
                    
                    //                    bottons section
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
                    .padding(.top, 70)
                    
                    Spacer(minLength: 0.0)
                }
            }
        }
        .alert(isPresented: $viewModel.alert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertDescription),
                dismissButton: .default(Text("OK")){
                    viewModel.alertDescription = ""
                }
            )
        }
        .navigationBarTitle("Edit Goal", displayMode: .inline)
        .toolbar(.hidden, for: .tabBar) //hides the tabBar!
        .navigationBarItems(trailing:
                                Button("Confirm") {
            Task {
                guard viewModel.validateFields() else {
                    return
                }
                await viewModel.updateFirebase()
                presentationMode.wrappedValue.dismiss() // Dismiss the view
                
            }
            
        })
    }
    
    
    private var propertyView: some View {
        
        VStack(spacing: 0) {
            
            CustomLineView(propertyName: Text("Title"), propertyValueString: $viewModel.goal.title, propertyValueInt: nil, errorAlert: viewModel.titleAlertPresense, errorText: "Field can't be empty").padding(.bottom, 2)
            Divider()
            
            CustomLineView(propertyName: Text("Aim"), propertyValueString: nil, propertyValueInt: $viewModel.goal.aim, errorAlert: viewModel.aimAlertPresense, errorText: "Value can't be 0 or over 1 million").padding(.bottom, 2)
            Divider()
            
            CustomLineView(propertyName: Text("Current count"), propertyValueString: nil, propertyValueInt: $viewModel.goal.currentNumber, errorAlert: viewModel.currentCountAlertPresense, errorText: "Value is too large. It can't be over 1 million.").padding(.bottom, 2)
            Divider()
            
            CustomLineView(propertyName: Text("Step"), propertyValueString: nil, propertyValueInt: $viewModel.goal.step, errorAlert: viewModel.stepAlertPresense, errorText: "Value can't be 0 or over 999").padding(.bottom, 2)
            
        }
        .padding(.top, 3)
        .padding(.leading)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(goal: Goal(id: UUID(), title: "Gym visits", aim: 10, step: 1, currentNumber: 1, color: "", arrayIndex: 0))
    }
}
