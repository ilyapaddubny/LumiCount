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
                    
                    ColorPicker(selectedColor: $viewModel.color)
                        .padding([.leading, .trailing])
                        .padding(.bottom, 10)

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
                    
                    
                    Spacer(minLength: 0.0)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
        .onAppear(){
            _ = viewModel.validateFields()
            viewModel.fetchExamples()
            print("✅ New goal was created")
        }
        .navigationBarTitle("New goal", displayMode: .inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarItems(trailing:
                                Button("Confirm") {
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
        )
    }
    
    private var propertyView: some View {
        
        VStack(spacing: 0) {
            
            CustomLineView(propertyName: Text("Title"), propertyValueString: $viewModel.goal.title, propertyValueInt: nil, errorAlert: viewModel.titleAlertPresense, errorText: "Field can't be empty").padding(.bottom, 2)
//            CustomFormLineView(viewModel: viewModel, propertyName: Text("Name"), propertyValue: $viewModel.goal.title, field: .emptyTitle).padding(.bottom, 2)
            Divider()
            
            CustomLineView(propertyName: Text("Aim"), propertyValueString: nil, propertyValueInt: $viewModel.goal.aim, errorAlert: viewModel.aimAlertPresense, errorText: "Value can't be 0 or over 1 million").padding(.bottom, 2)
//            CustomFormLineNumberView(viewModel: viewModel, propertyName: Text("Aim"), propertyValue: $viewModel.goal.aim, field: .zeroAim).padding(.bottom, 2)
            Divider()
            
            CustomLineView(propertyName: Text("Step"), propertyValueString: nil, propertyValueInt: $viewModel.goal.step, errorAlert: viewModel.stepAlertPresense, errorText: "Value can't be 0 or over 999").padding(.bottom, 2)
//            CustomFormLineNumberView(viewModel: viewModel, propertyName: Text("Step"), propertyValue: $viewModel.goal.step, field: .zeroStep).padding(.bottom, 2)
            
        }
        .padding(.top, 3)
        .padding(.leading)
    }
    
}

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView(uid: "8J0EVj40cEdAaW6n3WJB0YOcjVe2")
    }
}
