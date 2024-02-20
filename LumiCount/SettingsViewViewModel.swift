//
//  SettingsViewViewModel.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 19.02.2024.
//

import Foundation

class SettingsViewViewModel: ObservableObject {
    var goalID: String?
    @Published var goal: Goal
    
    init(goalID: String? ) {
        self.goalID = goalID
        
        let goals = UserDefaults(suiteName: "group.Paddubny.LumiCount")?.goals(forKey: "goals") ?? []

        if let index = goalID {
            goal = goals.first(where: {$0.id == index}) ?? Goal(title: "", aim: 1, step: 1, currentNumber: 0, color: "CustomOrange")
        } else {
            goal = Goal(title: "New goal", aim: 1, step: 1, currentNumber: 0, color: "CustomOrange")
        }
    }
    
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
    
    
    //MARK: - Intents
    
    func deleteGoal() {
        if let index = goals.firstIndex(where: {$0.id == goal.id}) {
            goals.remove(at: index)
            objectWillChange.send()
        }
    }
    
    func confirm() {
        if let index = goals.firstIndex(where: {$0.id == goal.id}) {
            //update existion goal
            goals[index] = goal
        } else {
            //adding a new goal
            goals.append(goal)
        }
        objectWillChange.send()
    }
    
   
}
