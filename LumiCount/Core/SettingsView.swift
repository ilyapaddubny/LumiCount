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
                        .frame(height: 43*4+1*3+3)
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
                                do {
                                    try await viewModel.deleteGoal()
                                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                                } catch {
                                    //                    TODO: handle error
                                    print("⚠️" + error.localizedDescription)
                                }
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
        .navigationBarTitle("Edit Goal", displayMode: .inline)
        .toolbar(.hidden, for: .tabBar) //hides the tabBar!
        .navigationBarItems(trailing:
                                Button("Confirm") {
            Task {
                do{
                    try await viewModel.updateFirebase()
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                } catch {
                    //                    TODO: handle error
                    print("⚠️" + error.localizedDescription)
                }
            }
            
        })
    }
    
    
    private var propertyView: some View {
        
        VStack(spacing: 0) {
            
            customFormLine(propertyName: Text("Name"), propertyValue: $viewModel.goal.title)
            Divider()
            
            customFormLine(propertyName: Text("Aim"), propertyValue: $viewModel.goal.aim)
            Divider()
            
            customFormLine(propertyName: Text("Current count"), propertyValue: $viewModel.currentCount)
            Divider()
            
            customFormLine(propertyName: Text("Step"), propertyValue: $viewModel.goal.step)
        }
        .padding(.top, 3)
        .padding(.leading)
    }
    
    private func customFormLine(
        propertyName: Text,
        propertyValue: Binding<String>
    ) -> some View {
        VStack(spacing: 0) {
            HStack{
                propertyName.black18()
                Spacer()
                TextField("Type the name", text: propertyValue)
                    .rightAlignment()
            }.frame(height: 43)
        }
    }
    
    private func customFormLine(
        propertyName: Text,
        propertyValue: Binding<Int>
    ) -> some View {
        VStack(spacing: 0) {
            HStack{
                propertyName.black18()
                Spacer()
                TextField("Enter value", value: propertyValue, formatter: NumberFormatter())
                    .rightAlignment()
                    .keyboardType(.numberPad)
            }.frame(height: 43)
        }
    }
    
    
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(goal: Goal(id: UUID(), title: "Gym visits", aim: 10, step: 1, currentNumber: 1, color: "", arrayIndex: 0))
    }
}
