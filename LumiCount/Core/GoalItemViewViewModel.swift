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


class GoalItemViewViewModel: ObservableObject {
    
    func getColor() -> Color {
//        TODO: add color map
        return Color.customGray
    }
    
    func addStep(goalID: String) {
        getGoal(by: goalID) { goal in
            if var goal = goal {
                // Use the goal instance
                print("✅ goal is \(goal)")
                
                goal.currentNumber += goal.step
                
                self.updateDataWIth(goal: goal)
            } else {
                // Failed to retrieve the goal
                print("⚠️ Failed to retrieve the goal.")
            }
        }
        
    }
    
    func updateDataWIth(goal: Goal){
        
        // Get current user id
        guard let uId = Auth.auth().currentUser?.uid else {
            print("⚠️ GoalItemViewViewModel: current user id wasn't found")
            return
        }
        
//        let db = Firestore.firestore()
//        db.collection("users")
//            .document(uId)
//            .collection("goals")
//            .document(goal.id.uuidString)
//            .setData(goal.asDictionary())
    }
    
    func getGoal(by goalID: String, completion: @escaping (Goal?) -> Void) {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            let goalsCollection = db.collection("users").document("\(userID)").collection("goals")
            let goalDocument = goalsCollection.document("\(goalID)")
            
            goalDocument.getDocument { snapshot, error in
                // Error check
                if error == nil {
                    if let snapshot = snapshot {
                        let goal = self.createGoal(from: snapshot.data() ?? ["id": "",
                                                                        "title": "",
                                                                        "step": "",
                                                                        "color": "",
                                                                        "aim": "",
                                                                        "currentNumber": "",
                                                                        "arrayIndex":""])
                        
                        if let goal = goal {
                            // Use the goal instance
                            print("✅ goal is \(goal)")
                            completion (goal)
                        } else {
                            // Failed to create goal from server response
                            print("⚠️ Failed to create goal from server response.")
                            completion(nil)
                        }
                    }
                } else {
                    // Handle the error
                    print("⚠️ GoalItemViewViewModel goalDocument.getDocument is nil")
                    print("⚠️ \(String(describing: error?.localizedDescription))")
                    completion(nil)
                }
            }
            
        } else {
            // No currently signed-in user
            print("No user is currently signed in")
            completion(nil)
        }
        
        completion(nil)
    }

    func createGoal(from response: [String: Any]) -> Goal? {
        guard
            let id = UUID(uuidString: response["id"] as! String),
            let title = response["title"] as? String,
            let step = response["step"] as? Int,
            let color = response["color"] as? String,
            let aim = response["aim"] as? Int,
            let currentNumber = response["currentNumber"] as? Int,
            let arrayIndex = response["arrayIndex"] as? Int
        else {
            return nil
        }
        
        return Goal(id: id, title: title, aim: aim, step: step, currentNumber: currentNumber, color: color, arrayIndex: arrayIndex)
    }
}
