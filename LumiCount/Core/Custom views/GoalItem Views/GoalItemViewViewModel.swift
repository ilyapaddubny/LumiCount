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
import WidgetKit

@MainActor
class GoalItemViewViewModel: ObservableObject {
    @Published var alert = false
    @Published var alertDescription = ""
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    private let userCollection = Firestore.firestore().collection(Constants.userCollection)
    
    
    private func goalsCollection() -> CollectionReference {
        userCollection.document(uid).collection(Constants.goalCollection)
    }
    
    /// Adds a step to the specified goal, updating the `currentNumber` property and persisting the changes to Firestore.
    ///
    /// - Parameter goalID: The unique identifier of the goal to update.
    /// - Throws: This function can throw errors related to goal retrieval, updating data, or error handling.
    func addStep(goalID: String) async {
        do {
            WidgetCenter.shared.reloadTimelines(ofKind: "GoalWidget")
            var goal = try await getGoal(by: goalID)
            goal.currentNumber += goal.step
            try await self.updateDataWIth(goal: goal)
        } catch {
            print("❗️GoalItemViewModel addStep() throws: \(alertDescription)")
            //TODO: handle the error
            self.alertDescription = error.localizedDescription
            self.alert = true
        }
    }
    
    /// Updates Firestore with the provided `Goal` object.
    ///
    /// - Parameter goal: The `Goal` object to update in Firestore.
    /// - Throws: This function can throw errors related to updating data in Firestore.
    func updateDataWIth(goal: Goal) async throws {
        let goalsCollection = goalsCollection()
        
        do {
            try goalsCollection.document(goal.id.uuidString)
                .setData(from: goal)
        } catch {
            throw error
        }
    }
    
    /// Retrieves a `Goal` object from Firestore using its unique identifier.
    ///
    /// - Parameter goalID: The unique identifier of the goal to retrieve.
    /// - Returns: The retrieved `Goal` object.
    /// - Throws: This function can throw errors related to retrieving the goal from Firestore or handling errors.
    func getGoal(by goalID: String) async throws -> Goal {
        let goalsCollection = goalsCollection()
        let goalDocument = goalsCollection.document(goalID)
        
        do {
            return try await goalDocument.getDocument(as: Goal.self)
        } catch {
            throw URLError(.cannotCreateFile)
        }
    }
    
    private struct Constants {
        static let userCollection = "users"
        static let goalCollection = "goals"

    }
}
