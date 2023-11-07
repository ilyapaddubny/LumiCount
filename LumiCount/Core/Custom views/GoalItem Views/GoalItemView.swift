//
//  GoalItemView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import SwiftUI

struct GoalItemView: View {
    
    var goal: Goal
    @StateObject var viewModel = GoalItemViewViewModel()
    
    
    var body: some View {
            Rectangle()
                .fill(Color.customBackgroundWhite)
                .overlay(
                    ZStack(alignment: .bottomLeading) {
                        BacgroundView(backgroundColor: Color(goal.color),
                                      size: CGSize(width: 1.0,
                                                   height: ( Double(goal.currentNumber) / Double(goal.aim)) ))
                        goalContent
                        .padding()
                        
                        HStack {
                            Spacer()
                            PlusButtonView {
                                Task { await viewModel.addStep(goalID: goal.id.uuidString) }
                            }
                            .padding(.trailing, Constants.buttonOffset)
                            .padding(.bottom, Constants.buttonOffset)
                        }
                    }
                )
                .cornerRadius(Constants.cornerRadius)
                .frame(width: Constants.tileHeight, height: Constants.tileHeight)
                .contentShape(.dragPreview, RoundedRectangle(cornerRadius: Constants.cornerRadius)) // https://stackoverflow.com/questions/72016849/ondrag-preview-isn-t-just-of-the-dragged-view-but-also-displays-the-background-t
                .alert(isPresented: $viewModel.alert) {
                    Alert(
                        title: Text(Constants.Strings.alertTitle),
                        message: Text(viewModel.alertDescription),
                        dismissButton: .default(Text(Constants.Strings.alertDismissButton))
                    )
                }
    }
    
    private var goalContent: some View {
        VStack(alignment: .leading) {
            Text(goal.title)
                .blackRegular(size: Constants.mediumTextSize)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.black)
            Spacer()
            HStack{
                Text("\(goal.currentNumber) / \(goal.aim)")
                    .blackRegular(size: Constants.mediumTextSize)
            }
            .foregroundColor(Color.black)
            .font(.custom(Constants.Strings.goalName, size: Constants.mediumTextSize))
            Spacer()
            Spacer()
            Text("\(Constants.Strings.step) \(goal.step)")
                .blackRegular(size: Constants.smallTextSize)
                .foregroundColor(Color.black)
        }
    }
    
    private struct Constants {
        static let cornerRadius = 15.0
        static let tileHeight = 170.0
        static let buttonOffset = -12.5
        
        static let mediumTextSize = 22.0
        static let smallTextSize = 16.0
        
        
        struct Strings {
            static let step = "Step"
            static let goalName = "Goals"
            static let alertTitle = "Error"
            static let alertMessage = "" //TODO: add alert logic here
            static let alertDismissButton = "OK"
        }
    }
}


struct GoalItemView_Previews: PreviewProvider {
    static var previews: some View {
        GoalItemView(goal: Goal(id: UUID(), title: "Some goal with a long name", aim: 2, step: 1, currentNumber: 1, color: "CustomRed", arrayIndex: 0))
    }
}
