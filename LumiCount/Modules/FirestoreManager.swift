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

enum FirebaseSoure {
    case cach, server
}

class FirestoreManager {
    static let shared = FirestoreManager()
    @Published var items: [Goal] = []
    
    private init() {}
    
    //MARK: - DB: Create
    func createNewGoal(_ goal: Goal) async throws {
        try await goalsCollection().document(goal.id.uuidString).setData(from: goal, merge: false)
    }
    
    //MARK: - DB: Read
    func getGoals(orderedBy: String,
                  source: FirestoreSource,
                  sortingField: String? = nil,
                  isGreaterThan: Int? = nil) async -> [Goal] {
        do {
            let query = await getOrderedGoalsQueryWhere(sortingField: sortingField,
                                                        isGreaterThan: isGreaterThan,
                                                        orderedBy: orderedBy)
            let snapshot: QuerySnapshot
            let log: String
            switch source {
            case .cache:
                snapshot = try await query.getDocuments(source: .cache)
                log = "🙂 getGoals: used cached data"
            default:
                snapshot = try await query.getDocuments(source: .server)
                log = "🙂 getGoals: used data from server"
            }
            
            return parseData(from: snapshot, log1: log)
        } catch {
            print("Error retrieving goals: \(error)")
            return []
        }
        
    }
    
    func getGoals(orderedBy: String,
                      source: FirestoreSource,
                      sortingField: String? = nil,
                      isGreaterThan: Int? = nil,
                      completion: @escaping ([Goal]) -> Void) async {
            do {
                let query = await getOrderedGoalsQueryWhere(sortingField: sortingField,
                                                            isGreaterThan: isGreaterThan,
                                                            orderedBy: orderedBy)
                let snapshot: QuerySnapshot
                let log: String
                switch source {
                case .cache:
                    snapshot = try await query.getDocuments(source: .cache)
                    log = "🙂 getGoals: used cached data"
                default:
                    snapshot = try await query.getDocuments(source: .server)
                    log = "🙂 getGoals: used data from server"
                }
                
                let goals = parseData(from: snapshot, log1: log)
                completion(goals)
            } catch {
                print("Error retrieving goals: \(error)")
                completion([])
            }
        }
    
    
    func getExamples() async throws -> [Goal] {
        let examplesCollection = exampleCollection()
        do{
            let snapshotCach = try await examplesCollection.getDocuments(source: .cache)
            let snapshotServer = try await examplesCollection.getDocuments(source: .server)
            
            let goals: [Goal] = parseData(from: snapshotCach, log1: "🙂 fetchExamples: used local data")
            return !goals.isEmpty ? goals : parseData(from: snapshotServer, log1: "🙂 fetchExamples: used datefrom server")
            
        } catch {
            print("Error retrieving goals: \(error)")
            return []
        }
    }
    
    /// Retrieves a `Goal` object from Firestore using its unique identifier.
    ///
    /// - Parameter goalID: The unique identifier of the goal to retrieve.
    /// - Returns: The retrieved `Goal` object.
    /// - Throws: This function can throw errors related to retrieving the goal from Firestore or handling errors.
    func getGoal(by goalID: String,
                 source: FirestoreSource) async throws -> Goal {
//                 source: FirestoreSource) async throws -> Goal {
        let goalsCollection = await goalsCollection()
        let goalDocument = goalsCollection.document(goalID)
        
        do {
            switch source {
            case .cache:
                //TODO: add cach
                let goal = try await goalDocument.getDocument(source: .default).data(as: Goal.self)
                print("🙂 getGoal: cashed goal")
                return goal
            default:
                let goal = try await goalDocument.getDocument(as: Goal.self)
                print("🙂 getGoal: goal from server")
                return goal
            }
            
        } catch {
//            TODO: handle errors
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
        let goalsCollection = await goalsCollection()
        
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
            var goal = try await getGoal(by: goalID, source: .server)
            goal.currentNumber += goal.step
            try await self.updateDataWIth(goal: goal)
            WidgetCenter.shared.reloadTimelines(ofKind: "GoalWidget")
        } catch {
            print("❗️GoalItemViewModel addStep() throws: \(error)")
            //TODO: handle the error
//            self.alertDescription = error.localizedDescription
//            self.alert = true
        }
//        _ = try? await getGoal(by: goalID, source: .server)
//        _ = await getGoals(orderedBy: "title", source: .server, completion: {_ in })
//        _ = await getGoals(orderedBy: "array_index", source: .server, completion: {_ in })
        WidgetCenter.shared.reloadTimelines(ofKind: "GoalWidget")
    }
    
   
    func updateGoals(_ goals: [Goal]) async throws {
        let goalsCollection = await goalsCollection()
            try goals.forEach { goal in
                let documentReference = goalsCollection.document(goal.id.uuidString)
                try documentReference.setData(from: goal, merge: false)
            }
//        _ = await getGoals(orderedBy: "title", source: .server, completion: {_ in })
//        _ = await getGoals(orderedBy: "array_index", source: .server, completion: {_ in })
        
    }
    
    func updateGoal(_ goal: Goal) async throws {
        let goalsCollection = await goalsCollection()
        let documentReference = goalsCollection.document(goal.id.uuidString)
        try documentReference.setData(from: goal, merge: false)
        
        _ = try? await getGoal(by: goal.id.uuidString, source: .server)
        _ = await getGoals(orderedBy: "title", source: .server, completion: {_ in })
        _ = await getGoals(orderedBy: "array_index", source: .server, completion: {_ in })
    }
    
    //MARK: - DB: Delete
    
    /// Deletes the current goal from Firestore and updates the goals' order after deletion.
    ///
    /// This function deletes the Firestore document associated with the current goal, and then updates the order of the remaining goals using the `deleteDragAndDropLogic` function. If any errors occur during this process, it sets an alert message to display an error.
    func deleteGoal(by id: String) async throws {
        let goalsCollection = await goalsCollection()
        let goalReference = goalsCollection.document(id)
        do {
            try await goalReference.delete()
            _ = await getGoals(orderedBy: "title", source: .server, completion: {_ in })
            _ = await getGoals(orderedBy: "array_index", source: .server, completion: {_ in })
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
    private func getOrderedGoalsQueryWhere(sortingField: String?, isGreaterThan: Int?, orderedBy orderField: String) async -> Query {
        let goalsCollection = await goalsCollection()
        let query = if let sortingField = sortingField, let isGreaterThan = isGreaterThan {
            goalsCollection
                .whereField(sortingField, isGreaterThan: isGreaterThan)
                .order(by: orderField)
        } else {
            goalsCollection
                .order(by: orderField)
        }
           return query
    }
    
    
    
    // MARK: - Private Helpers

        private func fetchSnapshots(from query: Query) async throws -> (QuerySnapshot?, QuerySnapshot?) {
            let snapshotCache = try await query.getDocuments(source: .cache)
            let snapshotServer = try await query.getDocuments(source: .server)
            return (snapshotCache, snapshotServer)
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
    
    private func goalsCollection() async -> CollectionReference {
        if uid.isEmpty {
            try? await authentication()
        }
        return userCollection.document(uid).collection(Constants.goalCollection)
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
