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
    
//    init(goalID: String) {
//        self.goalID = goalID
//        self._viewModel = GoalItemViewViewModel(goalID: goalID)
//    }
    
    
    var body: some View {
        
//        NavigationLink(destination: SettingsView(goal:
//                Goal(id: goal.id, title: goal.title, aim: goal.aim, step: goal.step, currentNumber: goal.currentNumber, color: goal.color, arrayIndex: goal.arrayIndex)
//        ), label: {
            Rectangle()
                .fill(Color.customBackgroundWhite)
                .overlay(
                    ZStack(alignment: .bottomLeading){
//                        TODO: calculate the size
                        BacgroundView(backgroundColor: Color(goal.color), size: CGSize(width: 1.0, height: ( Double(goal.currentNumber) / Double(goal.aim)) ))
                        VStack(alignment: .leading) {
                            Text(goal.title)
                                .foregroundColor(Color.black)
                                .font(.custom("GoalName", size: 26))
                            Spacer()
                            HStack{
                                Text("\(goal.currentNumber)")
                                Text("/")
                                Text("\(goal.aim)")
                            }
                            .foregroundColor(Color.black)
                            .font(.custom("GoalName", size: 26))
                            Spacer()
                            Spacer()
                            Text("Step \(goal.step)")
                                .foregroundColor(Color.black)
                        }
                        .padding()
                        HStack{
                            Spacer()
                            PlusButtonView {
                                viewModel.addStep(goalID: goal.id.uuidString)
                            }
                                .padding(.trailing, -12.5)
                                .padding(.bottom, -12.5)
                        }
                    }
                )
                .cornerRadius(15)
                .frame(height: 170)
//        })
            
        
            
    }
}


struct GoalItemView_Previews: PreviewProvider {
    static var previews: some View {
        GoalItemView(goal: Goal(id: UUID(), title: "Some goal", aim: 2, step: 1, currentNumber: 1, color: "CustomRed", arrayIndex: 0))
    }
}
