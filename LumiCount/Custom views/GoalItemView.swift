//
//  GoalItemView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import SwiftUI

struct GoalItemView: View {
    var goal: Goal
    var action: () -> Void
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    @Binding var confettiTrigger: Int

    var body: some View {
        Rectangle()
            .fill(Color.customBackgroundWhite)
            .overlay(
                ZStack(alignment: .bottomLeading) {
                    DynamicBacgroundView(backgroundColor: Color(goal.color),
                                  size: CGSize(width: 1.0, height: ( Double(goal.currentNumber) / Double(goal.aim)) ))
                    goalContent
                        .padding()
                    
                    HStack {
                        Spacer()
                        plusButton
                        .padding(.trailing, Constants.buttonOffset)
                        .padding(.bottom, Constants.buttonOffset)
                    }
                }
            )
            .cornerRadius(Constants.cornerRadius)
            .frame(width: Constants.tileHeight, height: Constants.tileHeight)
            .contentShape(.dragPreview, RoundedRectangle(cornerRadius: Constants.cornerRadius)) // https://stackoverflow.com/questions/72016849/ondrag-preview-isn-t-just-of-the-dragged-view-but-also-displays-the-background-t
            .onAppear {
                feedbackGenerator.prepare()
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
                Text("\(goal.currentNumber)")
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.2), value: goal.currentNumber)
                Text("/ \(goal.aim)")
//                Text("\(goal.currentNumber) / \(goal.aim)")
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
    
    private var plusButton: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: Constants.buttonHeight, height: Constants.buttonHeight)
                .overlay(
                    Button(action: {
                        feedbackGenerator.impactOccurred()
                        action()
                        guard (Double(goal.currentNumber + goal.step) / Double(goal.aim) == 1) else {
                            return
                        }
                        confettiTrigger += 1
                    }) {
                        Image(systemName: Constants.iconName)
                            .foregroundColor(.black)
                            .font(.custom("", size: Constants.iconSize))
                    }
                )
        }
    }
    
    private struct Constants {
        static let iconName = "plus"
        static let iconSize = 50.0
        static let buttonHeight = 70.0
        
        static let cornerRadius = 15.0
        static let tileHeight = 170.0
        static let buttonOffset = -12.5
        
        static let mediumTextSize = 22.0
        static let smallTextSize = 16.0
        
        
        struct Strings {
            static let step = "Step"
            static let goalName = "Goals"
        }
    }
}


struct GoalItemView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        GoalItemView(goal: Goal(title: "Some goal with a long name", aim: 2, step: 1, currentNumber: 1, color: "CustomRed"), action: {}, confettiTrigger: .constant(0))
    }
}
