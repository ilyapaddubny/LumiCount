//
//  SettingsViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 23.05.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

@MainActor
class SettingsViewViewModel: ObservableObject {
    
    init(goal: Goal) {
            self.goal = goal
            self.color = Color(goal.color)
            self.currentCount = goal.currentNumber
            self.propertiesHeight = CGFloat(fieldHeight*4+1*3+3+4*2)
        }
    
    func updateGoal() async {
        goal.color = color.getStringName()
        do {
            try await FirestoreManager.shared.updateGoal(goal)
        } catch {
            alertDescription = error.localizedDescription
            alert = true
        }
    }
    
    
    func deleteGoal() async {
        do {
            try await FirestoreManager.shared.deleteGoal(by: goal.id.uuidString)
            try await updateArrayIndexes()
        } catch {
            alertDescription = error.localizedDescription
            alert = true
        }
    }
    
    private func updateArrayIndexes() async throws {
        Goal.numberOfGoals -= 1
        var goals: [Goal] = []
        goals = await FirestoreManager.shared.getGoals(orderedBy: Constants.Strings.Firebase.indexArray,
                                                       source: .server,
                                                       sortingField: Constants.Strings.Firebase.indexArray,
                                                       isGreaterThan: goal.arrayIndex)
        goals.indices.forEach { index in
            goals[index].arrayIndex -= 1
        }
        
        do {
            try await FirestoreManager.shared.updateGoals(goals)
        } catch {
            throw URLError(.cannotConnectToHost)
        }
    }
    
    func resetCount() {
        goal.currentNumber = 0
        currentCount = 0
    }
    
    func validateFields() -> Bool {
        goal.title = goal.title.trimmingCharacters(in: .whitespaces)
        
        aimAlertPresense = goal.aim == 0 || goal.aim > 1_000_000
        stepAlertPresense = goal.step == 0 || goal.step > 999
        currentCountAlertPresense = goal.currentNumber > 1_000_000
        titleAlertPresense = goal.title.isEmpty
        
        calculateFormHeight()
        
        return !aimAlertPresense && !stepAlertPresense && !titleAlertPresense && !currentCountAlertPresense
        
    }
    
    func calculateFormHeight() {
        propertiesHeight = CGFloat(fieldHeight*4+1*3+3+4*2)
        propertiesHeight += extraFieldHeight*(titleAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(aimAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(stepAlertPresense ? 1 : 0)
        propertiesHeight += extraFieldHeight*(currentCountAlertPresense ? 1 : 0)
    }
    
    private struct Constants {
        
        struct Strings {
            struct Firebase {
                static let userCollection = "users"
                static let goalCollection = "goals"
                static let indexArray = "array_index"
            }
        }
    }
    
    @Published var titleAlertPresense = false
    @Published var aimAlertPresense = false
    @Published var stepAlertPresense = false
    @Published var currentCountAlertPresense = false
    
    @Published var propertiesHeight: CGFloat
    
    
    @Published var alert = false
    @Published var alertDescription = ""
    
    @Published var color: Color
    @Published var currentCount: Int
    
    var fieldHeight = CGFloat(43)
    var extraFieldHeight = CGFloat(8)
    
    private let uId = Auth.auth().currentUser?.uid ?? ""
    var goal: Goal
    var items: [Goal] = []
}
