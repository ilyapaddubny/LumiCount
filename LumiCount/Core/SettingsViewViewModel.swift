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
    private let uId = Auth.auth().currentUser?.uid ?? ""
    
    var goal: Goal
    var items: [Goal] = []
    
    
    @Published var color: Color
    @Published var currentCount: Int
    
    init(goal: Goal) {
            self.goal = goal
            self.color = Color(goal.color)
            self.currentCount = goal.currentNumber
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
    
    func updateFirebase() async throws {
        goal.color = color.getStringName()
        goal.currentNumber = currentCount
        
        let goalReference = await goalDocument()
        do {
            try goalReference.setData(from: goal)
        } catch {
            throw URLError(.badServerResponse)
        }
    }
    
    
    func deleteGoal() async throws {
        let goalReference = await goalDocument()
        do {
            try await goalReference.delete()
            try await deleteDragAndDropLogic()
        } catch {
            throw URLError(.badServerResponse)
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
                    throw URLError(.cancelled)
                }
            }
            
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
        
        self.items.forEach { goal in
            let documentReference = collectionRef.document(goal.id.uuidString)
            do {
                try documentReference.setData(from: goal, merge: false)
            } catch {
                // TODO: Handle error
                print(" TODO: Handle error documentRef.setData")
            }
            
        }
    }
    
    
    func resetCount() {
        currentCount = 0
    }
    
}
