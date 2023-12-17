//
//  NewGoalView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import SwiftUI

struct NewGoalView: View {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let uid: String
    
    @StateObject var viewModel: NewGoalViewViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    init(uid: String) {
        self.uid = uid
        self._viewModel = StateObject(wrappedValue: NewGoalViewViewModel(uid: uid))
        feedbackGenerator.prepare()
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
                    examplesleSection
                    Spacer(minLength: 0.0)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .alert(isPresented: $viewModel.alert) {
            Alert( //TODO: deprecated
                title: Text(Constants.Strings.alertTitle),
                message: Text(viewModel.alertDescription),
                dismissButton: .default(Text(Constants.Strings.alertDismissButton)){
                    viewModel.alertDescription = ""
                }
            )
        }
        .onAppear(){
            _ = viewModel.validateFields()
        }
        .task {
            await viewModel.fetchExamples()
        }
        .navigationTitle(Constants.Strings.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(Constants.Strings.confirm) {
                    guard viewModel.validateFields() else {
                        return
                    }
                    //            confirmation
                    feedbackGenerator.impactOccurred()
                    Task {
                        await viewModel.confirm()
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
            Text(Constants.Strings.backgroundSectionTitle)
                .black18()
                .padding(.leading, 28)
                .textCase(.uppercase)
            
            ColorPicker(selectedColor: $viewModel.color)
                .padding([.leading, .trailing])
                .padding(.bottom, 10)
        }
    }
    
    private var examplesleSection: some View {
        Group {
            Text("Examples")
                .black18()
                .padding(.leading, 28)
                .textCase(.uppercase)
            
            Rectangle()
                .fill(.white)
                .frame(height: viewModel.fieldHeight*CGFloat(viewModel.goalsExample.count)+3)
                .cornerRadius(10)
                .overlay {
                    VStack(spacing: 0) {
                        ForEach(viewModel.goalsExample, id: \.id) { item in
                            ExampleGoalRowView(title: item.title, circleColor: item.color, height: viewModel.fieldHeight)
                            {
                                viewModel.goal = item
                                viewModel.color = Color(item.color)
                                _ = viewModel.validateFields()
                                feedbackGenerator.impactOccurred()
                            }
                            Divider()
                        }
                    }
                }.padding([.leading, .trailing])
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
            static let navigationTitle = "New goal"
            
            static let alertTitle = "Error"
            static let alertDismissButton = "OK"
            
            static let goalTitle = "Title"
            static let goalTitleError = "Field can't be empty"
            static let goalAim = "Aim"
            static let goalAimError = "Value can't be 0 or over 1 million"
            static let goalStep = "Step"
            static let goalStepError = "Value can't be 0 or over 999"
            
        }
    }
    
}

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView(uid: "8J0EVj40cEdAaW6n3WJB0YOcjVe2")
    }
}
