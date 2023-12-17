//
//  NewGoalViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseFirestore
//import Combine


@MainActor
class NewGoalViewViewModel: ObservableObject {
    @Published var alert = false
    var alertDescription = ""
    
    var errorTitle = "Field can't be empty"
    @Published var errorAim = ""
    @Published var errorStep = ""
    
    @Published var  goalsExample: [Goal] = []
    
    @Published var titleAlertPresense = true
    @Published var aimAlertPresense = false
    @Published var stepAlertPresense = false
    
    var fieldHeight = CGFloat(43)
    var extraFieldHeight = CGFloat(8)
    
    @Published var propertiesHeight: CGFloat
    
    @Published var goal = Goal(id: UUID(), title: "", aim: 1, step: 1, currentNumber: 0, color: "", arrayIndex: Goal.numberOfGoals + 1)
    
    var currentNumber = 0
    @Published var color = Color.customBlueDodger
    

    init(uid: String) {
        self.propertiesHeight = CGFloat(fieldHeight*3+1*2+3+3*2)
    }
    
    func confirm() async {
        goal.color = color.getStringName()
        
//        all examples has a 999 arrayIndex
        if goal.arrayIndex == 999 {
            goal.arrayIndex = Goal.numberOfGoals + 1
            goal.id = UUID()
        }
        
        goal.arrayIndex = (goal.arrayIndex == 999) ? (Goal.numberOfGoals + 1) : goal.arrayIndex

        Goal.numberOfGoals += 1
        
//        confirm to the Firebase
        do {
            try await FirestoreManager.shared.createNewGoal(goal)
        } catch {
            alertDescription = error.localizedDescription
            alert = true
        }
        
    }
    
    
    func validateFields() -> Bool {
        goal.title = goal.title.trimmingCharacters(in: .whitespaces)
        
        aimAlertPresense = goal.aim == 0 || goal.aim > 1000000
        stepAlertPresense = goal.step == 0 || goal.step > 999
        titleAlertPresense = goal.title.isEmpty
        calculateFormHeight()
        return !aimAlertPresense && !stepAlertPresense && !titleAlertPresense
         
    }
    
    func calculateFormHeight() {
        propertiesHeight = CGFloat(fieldHeight*3+1*2+3+3*2)
        propertiesHeight += extraFieldHeight*(titleAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(aimAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(stepAlertPresense ? 1 : 0)
    }
    
    func fetchExamples() async {
            do {
                goalsExample = try await FirestoreManager.shared.fetchExamples()
            } catch {
                print("⚠️ fetchExamples: error on getting examples...")
                self.fetchLocalExamplesLocally()
            }
    }
    
    func fetchLocalExamplesLocally() {
//        if user can't get the examples from backend
        print("✅ fetchLocalExamplesLocally: examples loaded locally")
        goalsExample = [Goal(id: UUID(), title: "Drink 8 Glasses of Water", aim: 8, step: 1, currentNumber: 0, color: "CustomRed", arrayIndex: 999),
                        Goal(id: UUID(), title: "Visit 5 New Countries", aim: 5, step: 1, currentNumber: 0, color: "CustomBlueDodger", arrayIndex: 999),
                        Goal(id: UUID(), title: "5 books read", aim: 5, step: 1, currentNumber: 0, color: "CustomYellow", arrayIndex: 999),
                        Goal(id: UUID(), title: "Save $1000", aim: 1000, step: 10, currentNumber: 0, color: "CustomBlueAqua", arrayIndex: 999),
                        Goal(id: UUID(), title: "10 gym visits", aim: 10, step: 1, currentNumber: 0, color: "CustomPink", arrayIndex: 999)]
    }
}
