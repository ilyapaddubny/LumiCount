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
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    private let userCollection = Firestore.firestore().collection("users")
    @Published var items: [Goal] = []
    
    
    // Currently dragging goal
    @Published var draggingGoal: Goal?
    
    init() {
                initializeItems()
    }
    
    private func goalsCollection(uid: String) -> CollectionReference {
        userCollection.document(uid).collection("goals")
    }
    
    func initializeItems() {
        let orderedGoalsQuery = getAllGoalsQuery(orderBy: "array_index")
        
        orderedGoalsQuery
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    self?.alertDescription = "There was an issue loading your goals. Please check your internet connection and try again."
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
    
    
    private func getAllGoalsQuery(orderBy: String) -> Query {
        let goalsCollection = goalsCollection(uid: uid)
        return goalsCollection
            .order(by: orderBy)
    }
    
    // Used for drag and drop logic. Updates the goal.arrayIndex
    // Used to Update the order of [goal] in Firebase. For this purpose goal.arrayIndex was used
    func updateGoalsArray() async throws {
        
        let goalsCollection = goalsCollection(uid: uid)
        
        // Iterate over items array and update documents
        items.forEach { goal in
            let documentRef = goalsCollection.document(goal.id.uuidString)
            do {
                try documentRef.setData(from: goal) { error in
                    if let error = error {
                        self.alertDescription = error.localizedDescription
                        self.alert = true
                    }
                }
            } catch {
                self.alertDescription = error.localizedDescription
                self.alert = true
            }
        }
        
    }
    
    
   
}
