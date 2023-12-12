//
//  AddStepIntent.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 06.12.2023.
//

import Foundation
import AppIntents



struct AddStepIntent: AppIntent {
    init() {
    }
    static var title: LocalizedStringResource = "Add step"
    
    @Parameter(title: "Step")
    var step: Int
    
    @Parameter(title: "id")
    var id: String
    
    init(step: Int, id: String) {
        self.step = step
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        print("INTENT PLUS")
        
        await FirestoreManager.shared.addStep(goalID: id)
        
        return .result()
    }
    
    
    
    private struct Constants {
        static let orderField = "array_index"
        static let userCollection = "users"
        static let goalCollection = "goals"

    }
}


