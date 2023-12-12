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
    //
    @Published var widgetdGoal: Goal?

    
    var uid = ""
    private let userCollection = Firestore.firestore().collection(Constants.userCollection)
    @Published var items: [Goal] = []
    
    
    /// A published variable representing the currently dragged goal.
    @Published var draggingGoal: Goal?
    
    init() {
        initializeItems()
        if !items.isEmpty {
            widgetdGoal = items[0] // Set the initial selected goal (you can modify this based on your logic)
        }
    }
    
    private func goalsCollection(uid: String) -> CollectionReference {
        userCollection.document(uid).collection(Constants.goalCollection)
    }
    
    
    
    /// Initializes and populates the `items` array with goals.
    func initializeItems() {
        uid = Auth.auth().currentUser?.uid ?? ""
        let orderedGoalsQuery = getAllGoalsQuery(orderBy: Constants.orderField)
        
        if let orderedGoalsQuery = orderedGoalsQuery {
            orderedGoalsQuery
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    self?.alertDescription = Constants.Strings.alertDescription
                    self?.alert = true
                    return
                }
                
                // Map Firestore documents to Goal objects
                    let goals = documents.compactMap { document -> Goal? in
                        try? document.data(as: Goal.self)
                    }
                
                Goal.numberOfGoals = goals.count
                DispatchQueue.main.async {
                    self?.items = goals
                }
            }
        }
    }
    
    /// Generates a query to retrieve all goals based on the provided order.
    /// - Parameter orderBy: The field by which to order the results.
    /// - Returns: A Firestore query to retrieve goals or `nil` if the UID is empty.
    private func getAllGoalsQuery(orderBy: String) -> Query? {
        if !uid.isEmpty {
            let goalsCollection = goalsCollection(uid: uid)
            return goalsCollection
                .order(by: orderBy)
        }
        return nil
        
    }
    
    
    // Used for drag and drop logic. Updates the goal.arrayIndex
    /// Updates the order of goals in Firebase based on `arrayIndex`.
    func updateGoalsArray() async throws {
        guard !uid.isEmpty else { return }
        let goalsCollection = goalsCollection(uid: uid)
        
        items.forEach { goal in
            let documentRef = goalsCollection.document(goal.id.uuidString)
            do {
                try documentRef.setData(from: goal)
            } catch {
                self.alertDescription = error.localizedDescription
                self.alert = true
            }
        }
    }
    
    private struct Constants {
        static let orderField = "array_index"
        static let userCollection = "users"
        static let goalCollection = "goals"

        struct Strings {
            static let alertDescription = "There was an issue loading your goals. Please check your internet connection and try again."
        }
    }
   
}
