//
//  GoalItemViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 28.06.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class GoalItemViewViewModel: ObservableObject {
    @Published var alert = false
    @Published var alertDescription = ""
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    private let userCollection = Firestore.firestore().collection("users")
    
    
    private func goalsCollection() -> CollectionReference {
        userCollection.document(uid).collection("goals")
    }
    
    func addStep(goalID: String) async {
        do {
            var goal = try await getGoal(by: goalID)
            goal.currentNumber += goal.step
            
            try await self.updateDataWIth(goal: goal)
        } catch {
            print("❗️ GoalItemViewModel addStep() throws: \(alertDescription)")

            self.alertDescription = error.localizedDescription
            self.alert = true
        }
    }
    
    func updateDataWIth(goal: Goal) async throws {
        let goalsCollection = goalsCollection()
        
        do {
            try goalsCollection.document(goal.id.uuidString)
                .setData(from: goal)
        } catch {
            throw error
        }
    }
    
    
    func getGoal(by goalID: String) async throws -> Goal {
        let goalsCollection = goalsCollection()
        let goalDocument = goalsCollection.document(goalID)
        
        do {
            return try await goalDocument.getDocument(as: Goal.self)
        } catch {
            throw URLError(.cannotCreateFile)
        }
    }
}
