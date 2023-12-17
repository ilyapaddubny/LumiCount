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
    
    /// Adds a step to the specified goal, updating the `currentNumber` property and persisting the changes to Firestore.
    ///
    /// - Parameter goalID: The unique identifier of the goal to update.
    /// - Throws: This function can throw errors related to goal retrieval, updating data, or error handling.
    func addStep(goalID: String) async {
        
        do {
            await FirestoreManager.shared.addStep(goalID: goalID)
        } catch {
            print("❗️GoalItemViewModel addStep() throws: \(alertDescription)")
            //TODO: handle the error
            self.alertDescription = error.localizedDescription
            self.alert = true
        }
    }
    
    private struct Constants {
        static let userCollection = "users"
        static let goalCollection = "goals"

    }
}
