//
//  Goal.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 23.07.2023.
//

import Foundation
import AppIntents

struct Goal: Identifiable, Codable, AppEntity, AppValue {
    var id = UUID().uuidString
    var title: String
    var aim: Int
    var step: Int
    var currentNumber: Int 
    var color: String
    
    init(title: String, aim: Int, step: Int, currentNumber: Int, color: String) {
        self.title = title
        self.aim = aim
        self.step = step
        self.currentNumber = currentNumber
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case aim = "aim"
        case step = "step"
        case currentNumber = "current_number"
        case color = "color"
    }
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.aim = try container.decode(Int.self, forKey: .aim)
        self.step = try container.decode(Int.self, forKey: .step)
        self.currentNumber = try container.decode(Int.self, forKey: .currentNumber)
        self.color = try container.decode(String.self, forKey: .color)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.aim, forKey: .aim)
        try container.encode(self.step, forKey: .step)
        try container.encode(self.currentNumber, forKey: .currentNumber)
        try container.encode(self.color, forKey: .color)
    }
    
    static var defaultQuery = GoalQuery()
    static var typeDisplayRepresentation = TypeDisplayRepresentation("Goal")
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: title))
    }
    
    static var numberOfGoals = 0 {
        didSet {
            if numberOfGoals < 0 {
                numberOfGoals = 0
            }
        }
    }
    
}

struct GoalQuery: EntityQuery {
    /**
     Retrieves Goal entities for the specified identifiers.

     - Parameters:
         - identifiers: An array of Goal identifiers.

      - Returns: An array of Goal entities matching the provided identifiers.
     */
    func entities(for identifiers: [Goal.ID]) -> [Goal] {
        //trigered to retrieve widgets data
        guard let allGoals = UserDefaults(suiteName: "group.Paddubny.LumiCount")?.goals(forKey: "goals") else {
            return []
        }
        
        return allGoals.filter { identifiers.contains($0.id) }
    }
    
    /**
     Retrieves suggested Goal entities (used for pick forms).

     - Returns: An array of suggested Goal entities.
     */
    @MainActor
    func suggestedEntities() -> [Goal] {
        guard let allGoals = UserDefaults(suiteName: "group.Paddubny.LumiCount")?.goals(forKey: "goals") else {
            return []
        }
        
        return allGoals
    }
    
}

