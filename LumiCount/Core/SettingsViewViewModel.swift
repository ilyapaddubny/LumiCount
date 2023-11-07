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
    
    init(goal: Goal) {
            self.goal = goal
            self.color = Color(goal.color)
            self.currentCount = goal.currentNumber
            self.propertiesHeight = CGFloat(fieldHeight*4+1*3+3+4*2)
        }
    
    private func userReference() async -> DocumentReference {
        Firestore.firestore().collection(Constants.Strings.Firebase.userCollection).document(uId)
    }
    
    private func goalDocument() async -> DocumentReference {
        let userReference = await userReference()
        return userReference.collection(Constants.Strings.Firebase.goalCollection).document(goal.id.uuidString)
    }
    
    private func goalsCollection() async -> CollectionReference {
        let userReference = await userReference()
        return userReference.collection(Constants.Strings.Firebase.goalCollection)
    }
    
    func getUserID() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    /// Updates the Firestore document associated with the goal to reflect changes made in the `goal` object.
    ///
    /// This function sets the `color` property of the `goal` to its corresponding string name, and then updates the Firestore document with the updated `goal` data.
    ///
    /// - Throws: This function may throw errors related to updating the Firestore document or handling errors.
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
    
    /// Deletes the current goal from Firestore and updates the goals' order after deletion.
    ///
    /// This function deletes the Firestore document associated with the current goal, and then updates the order of the remaining goals using the `deleteDragAndDropLogic` function. If any errors occur during this process, it sets an alert message to display an error.
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
    
    /// Updates the order of goals in Firestore after deleting a goal
    ///
    /// This function decreases the `arrayIndex` of goals with an index greater than the deleted goal's `arrayIndex`, and then updates the Firestore documents for these goals. It also reduces the `Goal.numberOfGoals` by 1 to reflect the deleted goal.
    ///
    /// - Throws: This function may throw errors related to Firestore data retrieval, goal updates, or handling errors.
    private func deleteDragAndDropLogic() async throws {
        Goal.numberOfGoals -= 1
        var goals: [Goal] = []
        let query = await getOrderedGoalsQueryWhere(sortingField: Constants.Strings.Firebase.indexArray,
                                                    isGreaterThan: goal.arrayIndex,
                                                    orderedBy: Constants.Strings.Firebase.indexArray)
        
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
    
    /// Retrieves a Firestore `Query` to filter and order goals based on specific criteria.
    ///
    /// This function returns a `Query` that filters goals based on the provided `sortingField` where the field's value is greater than the specified `isGreaterThan` value. The results are then ordered by the `orderField`.
    ///
    /// - Parameters:
    ///   - sortingField: The field used for filtering goals.
    ///   - isGreaterThan: The value used as a threshold for filtering.
    ///   - orderField: The field used for ordering the results.
    /// - Returns: A Firestore `Query` for filtered and ordered goals.
    func getOrderedGoalsQueryWhere(sortingField: String, isGreaterThan: Int, orderedBy orderField: String) async -> Query {
        let goalsCollection = await goalsCollection()
        return goalsCollection
            .whereField(sortingField, isGreaterThan: isGreaterThan)
            .order(by: orderField)
    }
    
    /// Updates the order of goals in Firestore to reflect changes in the `items` array.
    ///
    /// This function iterates over the `items` array and updates the Firestore documents for each goal to ensure that their order matches the order in the array. If any errors occur during this process, they are propagated.
    ///
    /// - Throws: This function may throw errors related to updating the Firestore documents or handling errors.
    private func updateGoalArrayWithNewItemsOrder() async throws {
        let collectionRef = await goalsCollection()

            try self.items.forEach { goal in
                let documentReference = collectionRef.document(goal.id.uuidString)
                try documentReference.setData(from: goal, merge: false)
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
    
    private struct Constants {
        
        struct Strings {
            struct Firebase {
                static let userCollection = "users"
                static let goalCollection = "goals"
                static let indexArray = "array_index"
            }
        }
    }
    
    @Published var titleAlertPresense = false
    @Published var aimAlertPresense = false
    @Published var stepAlertPresense = false
    @Published var currentCountAlertPresense = false
    
    @Published var propertiesHeight: CGFloat
    
    
    @Published var alert = false
    @Published var alertDescription = ""
    
    @Published var color: Color
    @Published var currentCount: Int
    
    var fieldHeight = CGFloat(43)
    var extraFieldHeight = CGFloat(8)
    
    private let uId = Auth.auth().currentUser?.uid ?? ""
    var goal: Goal
    var items: [Goal] = []
}
