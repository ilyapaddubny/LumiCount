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
    private let goalCollection: CollectionReference
    
    private let exampleCollection = Firestore.firestore().collection("goals_example")

    init(uid: String) {
        self.goalCollection = Firestore.firestore().collection("users").document(uid).collection("goals")
        self.propertiesHeight = CGFloat(fieldHeight*3+1*2+3+3*2)
    }
    
    func confirm() async {
        guard let uId = Auth.auth().currentUser?.uid else {
            alertDescription = "Something went wrong. Current user wasn't found"
            alert = true
            return
        }
        
        goal.color = color.getStringName()
        
//        all examples has a 999 arrayIndex
        if goal.arrayIndex == 999 {
            goal.arrayIndex = Goal.numberOfGoals + 1
            goal.id = UUID()
        }
        
        goal.arrayIndex = (goal.arrayIndex == 999) ? (Goal.numberOfGoals + 1) : goal.arrayIndex

        Goal.numberOfGoals += 1
        

        do {
            try await createNewGoalWith(item: goal)
        } catch {
            alertDescription = error.localizedDescription
            alert = true
        }
        
    }
    
    
    func createNewGoalWith(item: Goal) async throws {
        _ = Firestore.firestore()
        try goalCollection.document(item.id.uuidString).setData(from: item, merge: false)
    }
    
    func validateFields() -> Bool {
        goal.title = goal.title.trimmingCharacters(in: .whitespaces)
        
        aimAlertPresense = goal.aim == 0
        stepAlertPresense = goal.step == 0
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
    
    func fetchExamples() {
        exampleCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                self.fetchLocalExamplesLocally()
                print("error on geatting examples...")
            } else {
                for document in querySnapshot!.documents {
                    print((try? document.data(as: Goal.self)) ?? "Error occurred")
                    let goalExample = try? document.data(as: Goal.self)
                    if let goalExample = goalExample {
                        self.goalsExample.append(goalExample)
                    }
                    
                }
            }
        }
    }
    
    func fetchLocalExamplesLocally() {
//        if user can't get the examples from backend
        goalsExample = [Goal(id: UUID(), title: "Drink 8 Glasses of Water", aim: 8, step: 1, currentNumber: 0, color: "CustomRed", arrayIndex: 999),
                        Goal(id: UUID(), title: "Visit 5 New Countries", aim: 5, step: 1, currentNumber: 0, color: "CustomBlueDodger", arrayIndex: 999),
                        Goal(id: UUID(), title: "5 books read", aim: 5, step: 1, currentNumber: 0, color: "CustomYellow", arrayIndex: 999),
                        Goal(id: UUID(), title: "Save $1000", aim: 1000, step: 10, currentNumber: 0, color: "CustomBlueAqua", arrayIndex: 999),
                        Goal(id: UUID(), title: "10 gym visits", aim: 10, step: 1, currentNumber: 0, color: "CustomPink", arrayIndex: 999)]
    }
}
