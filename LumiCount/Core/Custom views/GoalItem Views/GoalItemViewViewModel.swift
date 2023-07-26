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
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    private let userCollection = Firestore.firestore().collection("users")
    
    private func goalsCollection() -> CollectionReference {
        userCollection.document(uid).collection("goals")
    }
    
    func getColor() -> Color {
        //        TODO: add color map
        return Color.customGray
    }
    
    func addStep(goalID: String) async throws{
        var goal = try await getGoal(by: goalID)
        goal.currentNumber += goal.step
        
        //        TODO: deal with an throw
        try? await self.updateDataWIth(goal: goal)
        
    }
    
    func updateDataWIth(goal: Goal) async throws {
        let goalsCollection = goalsCollection()
        
        do {
            try goalsCollection.document(goal.id.uuidString)
                .setData(from: goal)
        } catch {
            throw URLError(.badServerResponse)
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
