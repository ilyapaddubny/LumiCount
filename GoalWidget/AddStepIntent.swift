//
//  AddStepIntent.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 06.12.2023.
//

import Foundation
import AppIntents



struct AddStepIntent: AppIntent {
    static var title: LocalizedStringResource = "Add step"
    
    @Parameter(title: "Step")
    var step: Int
    
    @Parameter(title: "id")
    var id: String
    
    /**
     Performs an asynchronous task and updates a goal's current number in a shared UserDefaults suite.

     - Returns: An IntentResult indicating the result of the operation.
     - Throws: An error if the operation encounters an issue.

     - Important: Assumes the existence of a struct or class named `IntentResult` and an array type named `Goal`.

     - Parameters:
        - id: The identifier of the goal to be updated. **/
    func perform() async throws -> some IntentResult {
        var goals: [Goal] {
            get {
                UserDefaults(suiteName: "group.Paddubny.LumiCount")?.goals(forKey: "goals") ?? []
            }
            set {
                if let sharedDefaults = UserDefaults(suiteName: "group.Paddubny.LumiCount") {
                    sharedDefaults.setValue(newValue, forKey: "goals")
                }
            }
        }
        
        if let goalIndex = goals.firstIndex(where: { $0.id == id }) {
            goals[goalIndex].currentNumber += goals[goalIndex].step
        }
        
        return .result()
    }
    
    init(step: Int, id: String) {
        self.step = step
        self.id = id
    }
    
    init() {  }
}


