//
//  FirestoreManager.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 06.12.2023.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth
import Firebase
import WidgetKit

class FirestoreManager {
    static let shared = FirestoreManager()
    
    init() {
//        CreateUser()
    }
    
    var ifUserExistInKeychain: Bool {
        var tempUser: User?
        do {
            tempUser = try Auth.auth().getStoredUser(forAccessGroup: Constants.accessGroup)
        } catch let error as NSError {
            print("❗️Error getting stored user: \(error)")
        }

        return tempUser != nil
    }
    
    func authentication() async throws {
        await CreateUser()
        
//        if Auth.auth().currentUser != nil {
//            print("ℹ️ User is already signed in")
//        } else if (try? await Auth.auth().signInAnonymously()) != nil {
//            try? await addNewUserToDB(Auth.auth().currentUser)
//        } else {
//            
////            self.alertDescription = Constants.Strings.alertDescription
////            self.alert = true
//        }
    }
    
    /// Adds a new user to the Firestore database.
    ///
    /// - Parameter user: An optional `User` object representing the new user.
    /// - Throws: This function may throw errors related to creating a new user.
    private func addNewUserToDB(_ user: User?) async throws  {
        var dbUser: DBUser
        if let user = user {
            dbUser = DBUser(userId: user.uid, isAnonymous: user.isAnonymous, dateCreated: Date())
            try? await createNewUser(dbUser: dbUser)
        }
    }
    
    /// Creates a new user in Firestore with the provided `DBUser` data.
    ///
    /// - Parameter dbUser: A `DBUser` object representing the user's data.
    /// - Throws: This function may throw errors related to setting user data in Firestore.
    private func createNewUser(dbUser: DBUser) async throws {
        try userDocument(userId: dbUser.userId).setData(from: dbUser, merge: false)
    }
    
    /// Returns a Firestore document reference for a user with the specified `userId`.
    ///
    /// - Parameter userId: The unique identifier of the user.
    /// - Returns: A Firestore `DocumentReference` for the user document.
    private func userDocument(userId: String) -> DocumentReference {
        userCollection.document(userId)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print("Error signing out: \(signOutError)")
        }
        
        do {
          try Auth.auth().useUserAccessGroup(nil)
        } catch let error as NSError {
          print("Error changing user access group: \(error)")
        }
    }
    
    
    //https://firebase.google.com/docs/auth/ios/single-sign-on?authuser=1
    func CreateUser() async {
        do {
            try Auth.auth().useUserAccessGroup(Constants.accessGroup)
        } catch let error as NSError {
          print("❗️Error changing user access group: \(error)")
        }
        
        
        guard ifUserExistInKeychain else {
            print("❗️No user exists in the access group")
            do {
                try await Auth.auth().signInAnonymously()
                try await addNewUserToDB(Auth.auth().currentUser)
            } catch {
                print("❗️Error signing in anonymously: \(error)")
            }
            return
        }
        
        let user = Auth.auth().currentUser
        guard let user = user else {
            fatalError("User is nil") //TODO: handle fatal error
        }
        
        do {
            try await Auth.auth().updateCurrentUser(user)
        } catch {
            print("FirestoreManager.shared.CreateUser(): \(error.localizedDescription)")
        }
        
    }
    
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    private let userCollection = Firestore.firestore().collection(Constants.userCollection)
    
    /// Adds a step to the specified goal, updating the `currentNumber` property and persisting the changes to Firestore.
    ///
    /// - Parameter goalID: The unique identifier of the goal to update.
    /// - Throws: This function can throw errors related to goal retrieval, updating data, or error handling.
    func addStep(goalID: String) async {
        do {
            var goal = try await getGoal(by: goalID)
            goal.currentNumber += goal.step
            try await self.updateDataWIth(goal: goal)
        } catch {
            print("❗️GoalItemViewModel addStep() throws: \(error)")
            //TODO: handle the error
//            self.alertDescription = error.localizedDescription
//            self.alert = true
        }
        
        WidgetCenter.shared.reloadAllTimelines()
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
    
    private func goalsCollection() -> CollectionReference {
        userCollection.document(uid).collection(Constants.goalCollection)
    }

    /// Retrieves all goals from the Firestore database and orders them by the specified order.
    ///
    /// - Parameter order: The order in which the goals should be returned. The possible values are `"title"`, `"aim"`, `"currentNumber"`, and  `"array_index"`.
    /// - Returns: A `[Goal]` array containing all goals from the Firestore database, ordered by the `"title"` parameter.
    func getAllGoalsOrdered(by order: String) async -> [Goal] {
        //TODO: cache the results of the getAllGoalsOrdered method so that the data doesn't have to be retrieved from Firestore every time the button is selected. This would also improve the performance of the app.
        
        await self.CreateUser()
        let orderedGoalsQuery = getAllGoalsQuery(orderBy: order)
        
        do {
            let orderedGoalsQuery = getAllGoalsQuery(orderBy: order)
            let snapshot = try await orderedGoalsQuery?.getDocuments()
            
            var goals: [Goal] = []
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let goal = try document.data(as: Goal.self)
                        goals.append(goal)
                    } catch {
                        print("Failed to convert document to Goal: \(error)")
                    }
                }
                
                return goals
            }
        } catch {
            print("Error retrieving goals: \(error)")
            return []
        }
        return []
    }
    
    
    
    /// Generates a query to retrieve all goals based on the provided order.
    /// - Parameter orderBy: The field by which to order the results.
    /// - Returns: A Firestore query to retrieve goals or `nil` if the UID is empty.
    private func getAllGoalsQuery(orderBy: String) -> Query? {
        if Auth.auth().currentUser != nil {
            let goalsCollection = goalsCollection()
            return goalsCollection
                .order(by: orderBy)
        }
        return nil
        
    }
    
    
    private struct Constants {
        static let userCollection = "users"
        static let goalCollection = "goals"
        
        static let accessGroup = "D6BK75VU2R.Paddubny.LumiCount.Shared" //TODO: hide the teamID

    }
}
