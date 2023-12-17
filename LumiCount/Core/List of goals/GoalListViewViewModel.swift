//
//  GoalListViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 02.06.2023.
//
import FirebaseFirestoreSwift
import Foundation
import FirebaseAuth
import Firebase

@MainActor
class GoalListViewViewModel: ObservableObject {
    
    @Published var alert = false
    @Published var alertDescription = ""

    @Published var items: [Goal] = []
    
    
    /// A published variable representing the currently dragged goal.
    @Published var draggingGoal: Goal?
    
    init() {
        Task {
            await initializeItems()
        }
    }
    
    /// Initializes and populates the `items` array with goals.
    func initializeItems() async {
        
        do {
            var goals = try await FirestoreManager.shared.getAllGoalsOrdered(by: Constants.goalPosition)
            Goal.numberOfGoals = goals.count
            DispatchQueue.main.async {
                self.items = goals
            }
        } catch {
            //TODO: deal with error
        }
        
        
//        uid = Auth.auth().currentUser?.uid ?? ""
//        let orderedGoalsQuery = getAllGoalsQuery(orderBy: Constants.goalPosition)
//        
//        if let orderedGoalsQuery = orderedGoalsQuery {
//            orderedGoalsQuery
//            .addSnapshotListener { [weak self] snapshot, error in
//                guard let documents = snapshot?.documents else {
//                    self?.alertDescription = Constants.Strings.alertDescription
//                    self?.alert = true
//                    return
//                }
//                
//                // Map Firestore documents to Goal objects
//                    let goals = documents.compactMap { document -> Goal? in
//                        try? document.data(as: Goal.self)
//                    }
//                
//                Goal.numberOfGoals = goals.count
//                DispatchQueue.main.async {
//                    self?.items = goals
//                }
//            }
//        }
    }
    
    // Used for drag and drop logic. Updates the goal.arrayIndex
    /// Updates the order of goals in Firebase based on `arrayIndex`.
    func updateGoalsArray() async throws {
        try await FirestoreManager.shared.updateGoals(items)
    }
    
    private struct Constants {
        static let goalPosition = "array_index"
        static let userCollection = "users"
        static let goalCollection = "goals"

        struct Strings {
            static let alertDescription = "There was an issue loading your goals. Please check your internet connection and try again."
        }
    }
   
}
