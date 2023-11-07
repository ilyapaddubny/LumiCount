//
//  RootViewViewModel.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 22.07.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class RootViewViewModel: ObservableObject {
    @Published var alert = false
    @Published var alertDescription = ""
    
    
    private let userCollection: CollectionReference = Firestore.firestore().collection(Constants.userCollection)
    
    /// Performs user authentication, either signing in an anonymous user or handling an already signed-in user.
    func authentication() async {
        if Auth.auth().currentUser != nil {
            print("ℹ️ User is already signed in")
        } else if (try? await Auth.auth().signInAnonymously()) != nil {
            try? await addNewUser(Auth.auth().currentUser)
        } else {
            self.alertDescription = Constants.Strings.alertDescription
            self.alert = true
        }
    }

    /// Adds a new user to the Firestore database.
    ///
    /// - Parameter user: An optional `User` object representing the new user.
    /// - Throws: This function may throw errors related to creating a new user.
    private func addNewUser(_ user: User?) async throws  {
        var dbUser: DBUser
        if let user = user {
            print("ℹ️ New anonymous user created: \(user.uid)")
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
    
    
    private struct Constants {
        static let userCollection = "users"
        struct Strings {
            static let alertDescription = "It's not possible to sign up. Something went wrong. Try to re-install the application."
        }
    }
}
