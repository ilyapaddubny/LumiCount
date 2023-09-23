//
//  SettingsViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class SettingsViewViewModel: ObservableObject {
    @Published var titleAlertPresense = false
    @Published var aimAlertPresense = false
    @Published var stepAlertPresense = false
    @Published var currentCountAlertPresense = false
    
    var fieldHeight = CGFloat(43)
    var extraFieldHeight = CGFloat(8)
    
    @Published var propertiesHeight: CGFloat
    
    
    @Published var alert = false
    @Published var alertDescription = ""
    
    @Published var color: Color
    @Published var currentCount: Int
    
    private let uId = Auth.auth().currentUser?.uid ?? ""
    var goal: Goal
    var items: [Goal] = []
    
    init(goal: Goal) {
            self.goal = goal
            self.color = Color(goal.color)
            self.currentCount = goal.currentNumber
            self.propertiesHeight = CGFloat(fieldHeight*4+1*3+3+4*2)
        }
    
    private func userReference() async -> DocumentReference {
        Firestore.firestore().collection("users").document(uId)
    }
    
    private func goalDocument() async -> DocumentReference {
        let userReference = await userReference()
        return userReference.collection("goals").document(goal.id.uuidString)
    }
    
    private func goalsCollection() async -> CollectionReference {
        let userReference = await userReference()
        return userReference.collection("goals")
    }
    
    func getUserID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    func updateFirebase() async {
        
        goal.color = color.getStringName()
        
        let goalReference = await goalDocument()
        do {
            try goalReference.setData(from: goal)
        } catch {
            alertDescription = error.localizedDescription
            alert = true
        }
    }
    
    
    func deleteGoal() async {
        let goalReference = await goalDocument()
        do {
            try await goalReference.delete()
            try await deleteDragAndDropLogic()
        } catch {
            alertDescription = error.localizedDescription
            alert = true
        }
    }
    
    private func deleteDragAndDropLogic() async throws {
        Goal.numberOfGoals -= 1
        var goals: [Goal] = []
        let query = await getOrderedGoalsQueryWhere(sortingField: "array_index", isGreaterThan: goal.arrayIndex, orderedBy: "array_index")
        
        if let querySnapshot = try? await query.getDocuments() {
            for document in querySnapshot.documents {
                do {
                    var goalData = try document.data(as: Goal.self)
                    goalData.arrayIndex -= 1
                    goals.append(goalData)
                    
                    self.items = goals
                    print(self.items)
                    try? await updateGoalArrayWithNewItemsOrder()
                } catch  {
                    throw error
                }
            }
        } else {
            throw URLError(.cannotConnectToHost)
        }
    }
    
    func getOrderedGoalsQueryWhere(sortingField: String, isGreaterThan: Int, orderedBy orderField: String) async -> Query {
        let goalsCollection = await goalsCollection()
        return goalsCollection
            .whereField(sortingField, isGreaterThan: isGreaterThan)
            .order(by: orderField)
    }
    
    private func updateGoalArrayWithNewItemsOrder() async throws {
        let collectionRef = await goalsCollection()
        
        do {
            try self.items.forEach { goal in
                let documentReference = collectionRef.document(goal.id.uuidString)
                do {
                    try documentReference.setData(from: goal, merge: false)
                } catch {
                    throw error
                }
            }
        } catch {
            throw error
        }
    }
    
    func resetCount() {
        goal.currentNumber = 0
        currentCount = 0
    }
    
    func validateFields() -> Bool {
        goal.title = goal.title.trimmingCharacters(in: .whitespaces)
        
        aimAlertPresense = goal.aim == 0 || goal.aim > 1_000_000
        stepAlertPresense = goal.step == 0 || goal.step > 999
        currentCountAlertPresense = goal.currentNumber > 1_000_000
        titleAlertPresense = goal.title.isEmpty
        
        calculateFormHeight()
        
        return !aimAlertPresense && !stepAlertPresense && !titleAlertPresense && !currentCountAlertPresense
        
    }
    
    func calculateFormHeight() {
        propertiesHeight = CGFloat(fieldHeight*4+1*3+3+4*2)
        propertiesHeight += extraFieldHeight*(titleAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(aimAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(stepAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(currentCountAlertPresense ? 1 : 0)
    }
}
