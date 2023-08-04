//
//  ProfileViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class ProfileViewViewModel: ObservableObject {
    @Published var user: User? = nil
    var formattedDate = ""
    
    func fetchUser(){
//        guard let userId = Auth.auth().currentUser?.uid else{
//            return
//        }
//
//        let db = Firestore.firestore()
//        db.collection("users").document(userId).getDocument{ [weak self] snapshot, error in
//            guard let data = snapshot?.data(), error == nil else{
//                return
//            }
//
//            DispatchQueue.main.async {
//                self?.user = User(
//                    id: data["id"] as? String ?? "",
//                    email: data["email"] as? String ?? "",
//                    name: data["name"] as? String ?? "",
//                    joined: data["joined"] as? TimeInterval ?? 0
//                )
//
//                self?.setFormattedDate()
//            }
//
//        }
    }
    
    func setFormattedDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        // US English Locale (en_US)
//        dateFormatter.locale = Locale(identifier: "en_US")
//        formattedDate = dateFormatter.string(from:
//                                    NSDate(timeIntervalSince1970: self.user?.joined ?? 0) as Date) // Jan 2, 2001
    }
    
    func logOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            print(error)
        }
    }
    
}
