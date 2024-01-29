//
//  GoalListViewViewModel.swift
//  CountMate
//
//  Created by Ilya Paddubny on 02.06.2023.
//
import Foundation
//import WidgetKit

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

@MainActor
class GoalListViewViewModel: ObservableObject {
    @Published var draggingGoal: Goal?
    @Published private var _cursorIndex = 0
    
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
    
    func deleteGoal(id: String) {
        if let index = goals.firstIndex(where: {$0.id == id}) {
            goals.remove(at: index)
            objectWillChange.send()
        }
    }
    
    init(alert: Bool = false, draggingGoal: Goal? = nil) {
        self.draggingGoal = draggingGoal
        
    }
    
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
    
    func insert(_ goal: Goal, at insertionIndex: Int? = nil) { // "at" default is cursorIndex
        let insertionIndex = boundsCheckedGoalIndex(insertionIndex ?? cursorIndex)
        if let index = goals.firstIndex(where: {$0.id == goal.id}) {
            goals.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex)
            goals.replaceSubrange(insertionIndex...insertionIndex, with: [goal])
        } else {
            goals.insert(goal, at: insertionIndex)
        }
    }
    
    var cursorIndex: Int {
        get { boundsCheckedGoalIndex(_cursorIndex) }
        set { _cursorIndex = boundsCheckedGoalIndex(newValue) }
    }
    
    func boundsCheckedGoalIndex(_ index: Int) -> Int {
        var index = goals.isEmpty ? 0 : index % goals.count
        if index < 0 {
            index += goals.count
        }
        return index
    }
    
    deinit {
        print("🔴 GoalListViewViewModel: deinit")
    }
   
}
