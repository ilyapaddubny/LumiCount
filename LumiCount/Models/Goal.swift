//
//  Goal.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 23.07.2023.
//

import Foundation

struct Goal: Identifiable, Codable {
    
    static var numberOfGoals = 0 {
        didSet {
            if numberOfGoals < 0 {
                numberOfGoals = 0
            }
        }
    }
    
    var id: UUID
    var title: String
    var aim: Int
    var step: Int
    var currentNumber: Int
    var color: String
    var arrayIndex: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case aim = "aim"
        case step = "step"
        case currentNumber = "current_number"
        case color = "color"
        case arrayIndex = "array_index"
    }
    
    init(id: UUID, title: String, aim: Int, step: Int, currentNumber: Int, color: String, arrayIndex: Int) {
        self.id = id
        self.title = title
        self.aim = aim
        self.step = step
        self.currentNumber = currentNumber
        self.color = color
        self.arrayIndex = arrayIndex
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.aim = try container.decode(Int.self, forKey: .aim)
        self.step = try container.decode(Int.self, forKey: .step)
        self.currentNumber = try container.decode(Int.self, forKey: .currentNumber)
        self.color = try container.decode(String.self, forKey: .color)
        self.arrayIndex = try container.decode(Int.self, forKey: .arrayIndex)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.aim, forKey: .aim)
        try container.encode(self.step, forKey: .step)
        try container.encode(self.currentNumber, forKey: .currentNumber)
        try container.encode(self.color, forKey: .color)
        try container.encode(self.arrayIndex, forKey: .arrayIndex)
    }
    
}
