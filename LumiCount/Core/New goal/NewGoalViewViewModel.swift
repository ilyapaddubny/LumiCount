//
//  NewGoalViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseFirestore

@MainActor
class NewGoalViewViewModel: ObservableObject {
    @Published var title = ""
    @Published var aim = 1
    @Published var step = 1
    @Published var currentNumber = 0
    @Published var color = Color.customBlueDodger
    private let goalCollection: CollectionReference

    init(uid: String) {
        self.goalCollection = Firestore.firestore().collection("users").document(uid).collection("goals")
    }
    
    func confirm() async {
        guard canConfirm else {
            return
        }
        
        guard let uId = Auth.auth().currentUser?.uid else {
            print("⚠️ NewGoalViewViewModel: current user id wasn't found")
            return
        }
        
        let newItem = Goal(id: UUID(),
                            title: title,
                            aim: aim,
                            step: step,
                            currentNumber: currentNumber,
                            color: color.getStringName(),
                            arrayIndex: Goal.numberOfGoals + 1)
        
        Goal.numberOfGoals += 1

        do {
            try await createNewGoalWith(item: newItem)
        } catch {
            print(error.localizedDescription)
        }
//        23/07
        
//        db.collection("users")
//            .document(uId)
//            .collection("goals")
//            .document(newItem.id.uuidString)
//            .setData(newItem.asDictionary())
        
    }
    
    func createNewGoalWith(item: Goal) async throws {
        let db = Firestore.firestore()
        try goalCollection.document(item.id.uuidString).setData(from: item, merge: false)
    }
    
    var canConfirm: Bool {
//        TODO: check if data is valid
        return true
    }
}
