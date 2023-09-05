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
    
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("users")
    
    func authentication() async {
//        try? Auth.auth().signOut()
        if Auth.auth().currentUser !== nil {
            print("ℹ️ user is already signed in")
        } else {
            if (try? await Auth.auth().signInAnonymously()) != nil {
                try? await addNewUser(user: Auth.auth().currentUser)
            } else {
                self.alertDescription = "It's not possible to sign up. Something went wrong. Try to re-install the application."
                self.alert = true
            }
            
        }
    }

    private func addNewUser(user: User?) async throws  {
        var dbUser: DBUser
        if let user = user {
            print("ℹ️ New anonymous user created: \(user.uid)")
            dbUser = DBUser(userId: user.uid, isAnonymous: user.isAnonymous, dateCreated: Date())
            try? await createNewUser(dbUser: dbUser)
        }
    }
    
    private func createNewUser(dbUser: DBUser) async throws {
        try userDocument(userId: dbUser.userId).setData(from: dbUser, merge: false)
       }
    
    private func userDocument(userId: String) -> DocumentReference {
           userCollection.document(userId)
       }
    
}
