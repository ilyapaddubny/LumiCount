//
//  NewGoalView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import SwiftUI

struct NewGoalView: View {
    
    let uid: String
    
    @StateObject var viewModel: NewGoalViewViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(uid: String) {
        self.uid = uid
        self._viewModel = StateObject(wrappedValue: NewGoalViewViewModel(uid: uid))
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
                        .frame(height: 43*3+1*2+3)
                        .padding([.leading, .trailing])
                        .padding(.bottom, 10)
                    
                    //                    color picker section
                    Text("Background color")
                        .black18()
                        .padding(.leading, 28)
                        .textCase(.uppercase)
                    
//  23/07
                    
                    ColorPicker(selectedColor: $viewModel.color)
                        .padding([.leading, .trailing])
                        .padding(.bottom, 10)

                    Text("Examples")
                        .black18()
                        .padding(.leading, 28)
                        .textCase(.uppercase)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(height: 43*4+3)
                        .cornerRadius(10)
                        .overlay {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Read 5 books")
                                    .frame(height: 43)
                                Divider()
                                Text("Gym visits")
                                    .frame(height: 43)
                                Divider()
                                Text("Visitors")
                                    .frame(height: 43)
                                Divider()
                                Text("Days sober")
                                    .frame(height: 43)
                            }
                            .padding([.leading, .trailing])
                        }
                        .padding([.leading, .trailing])
                    
                    
                    Spacer(minLength: 0.0)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationBarTitle("New goal", displayMode: .inline)
        .toolbar(.hidden, for: .tabBar)
        .navigationBarItems(trailing:
                                Button("Confirm") {
            //            confirmation
            Task {
                await viewModel.confirm()
                presentationMode.wrappedValue.dismiss() // Dismiss the view
            }
            
        }
        ).accentColor(Color.black)
    }
    
    private var propertyView: some View {
        
        VStack(spacing: 0) {
            
            customFormLine(propertyName: Text("Name"), propertyValue: $viewModel.title)
            Divider()
            
            customFormLine(propertyName: Text("Aim"), propertyValue: $viewModel.aim)
            Divider()
            
            customFormLine(propertyName: Text("Step"), propertyValue: $viewModel.step)
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

struct NewGoalView_Previews: PreviewProvider {
    static var previews: some View {
        NewGoalView(uid: "8J0EVj40cEdAaW6n3WJB0YOcjVe2")
    }
}
