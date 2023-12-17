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
    
    private init() {
    }
    
    //MARK: - DB: Create
    func createNewGoal(_ goal: Goal) async throws {
        try goalsCollection().document(goal.id.uuidString).setData(from: goal, merge: false)
    }
    
    //MARK: - DB: Read
    
    /// Retrieves all goals from the Firestore database and orders them by the specified order.
    ///
    /// - Parameter order: The order in which the goals should be returned. The possible values are `"title"`, `"aim"`, `"currentNumber"`, and  `"array_index"`.
    /// - Returns: A `[Goal]` array containing all goals from the Firestore database, ordered by the `"title"` parameter.
    func getAllGoalsOrdered(by order: String) async -> [Goal] {
        //TODO: cache the results of the getAllGoalsOrdered method so that the data doesn't have to be retrieved from Firestore every time the button is selected. This would also improve the performance of the app.
        
        do {
            let orderedGoalsQuery = getGoalsQuery(orderBy: order)
            
            let snapshotCach = try await orderedGoalsQuery?.getDocuments(source: .cache)
            let snapshotServer = try await orderedGoalsQuery?.getDocuments(source: .server)
            
            let goals: [Goal] = parseData(from: snapshotCach, log1: "🙂 getAllGoalsOrdered: used local date")
            return !goals.isEmpty ? goals : parseData(from: snapshotServer, log1: "🙂 getAllGoalsOrdered: used datefrom server")
        } catch {
            print("Error retrieving goals: \(error)")
            return []
        }
    }
    
    func getGoals(sortingField: String,
                  isGreaterThan: Int,
                  orderedBy: String) async -> [Goal] {
        do {
            let query = await getOrderedGoalsQueryWhere(sortingField: sortingField,
                                                        isGreaterThan: isGreaterThan,
                                                        orderedBy: orderedBy)
            
            let snapshotCach = try await query.getDocuments(source: .cache)
            let snapshotServer = try await query.getDocuments(source: .server)
            
            let goals: [Goal] = parseData(from: snapshotCach, log1: "🙂 getGoals: used local date")
            return !goals.isEmpty ? goals : parseData(from: snapshotServer, log1: "🙂 getGoals: used datefrom server")
        } catch {
            print("Error retrieving goals: \(error)")
            return []
        }
        
    }
    
    
    func fetchExamples() async throws -> [Goal] {
        let examplesCollection = exampleCollection()
        do{
            let snapshotCach = try await examplesCollection.getDocuments(source: .cache)
            let snapshotServer = try await examplesCollection.getDocuments(source: .server)
            
            let goals: [Goal] = parseData(from: snapshotCach, log1: "🙂 fetchExamples: used local date")
            return !goals.isEmpty ? goals : parseData(from: snapshotServer, log1: "🙂 fetchExamples: used datefrom server")
            
        } catch {
            print("Error retrieving goals: \(error)")
            return []
        }
    }
    
    func getGoalsWithListener(){}//send [goals] into a model
    
    /// Retrieves a `Goal` object from Firestore using its unique identifier.
    ///
    /// - Parameter goalID: The unique identifier of the goal to retrieve.
    /// - Returns: The retrieved `Goal` object.
    /// - Throws: This function can throw errors related to retrieving the goal from Firestore or handling errors.
    func getGoal(by goalID: String) async throws -> Goal {
        let goalsCollection = goalsCollection()
        let goalDocument = goalsCollection.document(goalID)
        
        do {
            let goal = try await goalDocument.getDocument(source: .cache).data(as: Goal.self)
            print("🙂 getGoal: cashed goal")
            return goal
        } catch {
//            TODO: nothing
        }
        
        do {
            let goal = try await goalDocument.getDocument(as: Goal.self)
            print("🙂 getGoal: goal from server")
            return goal
        } catch {
            print("⚠️ getGoal: \(error)")
            throw URLError(.unknown)
        }
    }
    
    
    
    func parseData(from snapshot: QuerySnapshot?, log1: String) -> [Goal] {
        var goals: [Goal] = []
        print(log1)
        if let snapshot = snapshot {
            for document in snapshot.documents {
                do {
                    let goal = try document.data(as: Goal.self)
                    goals.append(goal)
                } catch {
                    print("Failed to convert document to Goal: \(error)")
                }
            }
        }
        return goals
    }
    
    //MARK: - DB: Update
    
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
    
    /// Adds a step to the specified goal, updating the `currentNumber` property and persisting the changes to Firestore.
    ///
    /// - Parameter goalID: The unique identifier of the goal to update.
    /// - Throws: This function can throw errors related to goal retrieval, updating data, or error handling.
    func addStep(goalID: String) async {
        do {
            var goal = try await getGoal(by: goalID)
            goal.currentNumber += goal.step
            try await self.updateDataWIth(goal: goal)
            WidgetCenter.shared.reloadTimelines(ofKind: "GoalWidget")
        } catch {
            print("❗️GoalItemViewModel addStep() throws: \(error)")
            //TODO: handle the error
//            self.alertDescription = error.localizedDescription
//            self.alert = true
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "GoalWidget")
    }
    
   
    func updateGoals(_ goals: [Goal]) async throws {
        let goalsCollection = goalsCollection()
            try goals.forEach { goal in
                let documentReference = goalsCollection.document(goal.id.uuidString)
                try documentReference.setData(from: goal, merge: false)
            }
    }
    
    func updateGoal(_ goal: Goal) async throws {
        let goalsCollection = goalsCollection()
        let documentReference = goalsCollection.document(goal.id.uuidString)
        try documentReference.setData(from: goal, merge: false)
    }
    
    //MARK: - DB: Delete
    
    /// Deletes the current goal from Firestore and updates the goals' order after deletion.
    ///
    /// This function deletes the Firestore document associated with the current goal, and then updates the order of the remaining goals using the `deleteDragAndDropLogic` function. If any errors occur during this process, it sets an alert message to display an error.
    func deleteGoal(by id: String) async throws {
        let goalsCollection = goalsCollection()
        let goalReference = goalsCollection.document(id)
        do {
            try await goalReference.delete()
        } catch {
           throw error
        }
    }
    
    
    //MARK: - Auth
    
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
    
    /**
     Creates a user and manages their authentication state in Firebase.

     This function performs the following steps:
     1. Sets the user access group for Firebase authentication to a specified value.
     2. Checks if a user already exists in the access group.
        - If no user exists, signs in the user anonymously and adds them to the Firebase database.
        - If a user exists, updates the current user in the Firebase authentication state.

     This function is designed for asynchronous execution using the `async` keyword.

     - Throws: An error if changing the user access group fails, signing in anonymously fails, or updating the current user fails.
     - Note: Make sure to handle errors appropriately in the calling code.

     Example usage:
     ```swift
     do {
        try await CreateUser()
     } catch {
        print("Error creating user: \(error)")
     }
     */
    func authentication() async throws {
        //https://firebase.google.com/docs/auth/ios/single-sign-on?authuser=1
        setUserAccessGroup()
        
        guard ifUserExistInKeychain else {
            print("❗️No user exists in the access group")
            do {
                try await Auth.auth().signInAnonymously()
                try await addNewUserToDB(Auth.auth().currentUser)
            } catch {
                print("❗️Error signing in anonymously: \(error)")
                throw error
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
    
    func setUserAccessGroup() {
        do {
            try Auth.auth().useUserAccessGroup(Constants.accessGroup)
        } catch let error as NSError {
          print("❗️Error changing user access group: \(error)")
        }
    }
    
    let uid = Auth.auth().currentUser?.uid ?? ""
    private let userCollection = Firestore.firestore().collection(Constants.userCollection)
    
    
    //MARK: - queries
    
    /// Generates a query to retrieve all goals based on the provided order.
    /// - Parameter orderBy: The field by which to order the results.
    /// - Returns: A Firestore query to retrieve goals or `nil` if the UID is empty.
    private func getGoalsQuery(orderBy: String) -> Query? {
        if Auth.auth().currentUser != nil {
            let goalsCollection = goalsCollection()
            return goalsCollection
                .order(by: orderBy)
        }
        return nil
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
        let goalsCollection = goalsCollection()
        return goalsCollection
            .whereField(sortingField, isGreaterThan: isGreaterThan)
            .order(by: orderField)
    }
    
    //MARK: - other
    
    var ifUserExistInKeychain: Bool {
        var tempUser: User?
        do {
            tempUser = try Auth.auth().getStoredUser(forAccessGroup: Constants.accessGroup)
        } catch let error as NSError {
            print("❗️Error getting stored user: \(error)")
        }

        return tempUser != nil
    }
    
    private func goalsCollection() -> CollectionReference {
        userCollection.document(uid).collection(Constants.goalCollection)
    }
    
    private func exampleCollection() -> CollectionReference {
        Firestore.firestore().collection(Constants.exampleCollection)
    }
    
    private struct Constants {
        static let userCollection = "users"
        static let goalCollection = "goals"
        static let exampleCollection = "goals_example"
        
        static let accessGroup = "D6BK75VU2R.Paddubny.LumiCount.Shared" //TODO: hide the teamID

    }
}
