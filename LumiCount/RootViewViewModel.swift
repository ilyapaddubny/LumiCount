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

// TODO: handle errors
enum AnonymousSignInError: Error {
    case signInFailed
}

@MainActor
final class RootViewViewModel: ObservableObject {
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    
    func Authentication() async throws {
        if Auth.auth().currentUser !== nil {
            print("ℹ️ user is already signed in")
        } else {
            print("ℹ️ sign up a new user")
            if (try? await Auth.auth().signInAnonymously()) != nil {
                try? await addNewUser(user: Auth.auth().currentUser)
            } else {
                print("⚠️ Error: can't sign up a user")
                throw AnonymousSignInError.signInFailed
            }
            
        }
    }
    
    private func addNewUser(user: User?) async throws  {
        var dbUser: DBUser
        
        if let user = user {
            dbUser = DBUser(userId: user.uid, isAnonymous: user.isAnonymous, dateCreated: Date())
            try? fetchUser(dbUser: dbUser)
        }
    }
    
    private func fetchUser(dbUser: DBUser) throws {
        try userDocument(userId: dbUser.userId).setData(from: dbUser, merge: false)
       }
    
    private func userDocument(userId: String) -> DocumentReference {
           userCollection.document(userId)
       }
    
    
}
