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
    
    
    
    
    
    /// Performs user authentication, either signing in an anonymous user or handling an already signed-in user.
    func authentication() async {
        //TODO: handle errors
        try? await FirestoreManager.shared.authentication()
    }

    private struct Constants {
        struct Strings {
            static let alertDescription = "It's not possible to sign up. Something went wrong. Try to re-install the application."
        }
    }
}
