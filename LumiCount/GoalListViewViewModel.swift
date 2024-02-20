//
//  GoalListViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 02.06.2023.
//
import Foundation
import SwiftUI

class GoalListViewViewModel: ObservableObject {
    @Published var draggingGoal: Goal?
    
    private let name = "goals"
    
    var goals: [Goal] {
        get {
            UserDefaults(suiteName: "group.Paddubny.LumiCount")?.goals(forKey: name) ?? []
        }
        set {
            if let sharedDefaults = UserDefaults(suiteName: "group.Paddubny.LumiCount") {
                sharedDefaults.setValue(newValue, forKey: name)
            }
            objectWillChange.send()
        }
    }
    
    init(alert: Bool = false, draggingGoal: Goal? = nil) {
        self.draggingGoal = draggingGoal
    }
    
    //MARK: - Intents
    func getGoalBy(_ id: String) -> Goal? {
        if let index = goals.firstIndex(where: {$0.id == id}) {
            return goals[index]
        }
        return nil
    }
    
    func addStep(goalID: String) {
        if let goalIndex = goals.firstIndex(where: { $0.id == goalID }) {
            goals[goalIndex].currentNumber += goals[goalIndex].step
        }
    }
   
}


extension UserDefaults {
    func goals(forKey key: String) -> [Goal] {
        if let jsonData = data(forKey: key),
           let decodedGoals = try? JSONDecoder().decode([Goal].self, from: jsonData) {
            return decodedGoals
        } else {
            return []
        }
    }
    
    func setValue(_ goals: [Goal], forKey key: String) {
        if goals.isEmpty {
            removeObject(forKey: key)
        } else {
            if let encodedData = try? JSONEncoder().encode(goals) {
                set(encodedData, forKey: key)
            }
        }
    }
}
