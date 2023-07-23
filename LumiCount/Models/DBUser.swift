//
//  UserDB.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 22.07.2023.
//

import Foundation

struct DBUser: Codable {
    
    var userId: String
    var isAnonymous: Bool
    var dateCreated: Date
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case isAnonymous = "is_anonymous"
        case dateCreated = "date_created"
    }
    
    //    let email: String?
    //    let photoUrl: String?
    //    let isPremium: Bool?
    //    let preferences: [String]?
    //    let profileImagePath: String?
    //    let profileImagePathUrl: String?
    
    init(userId: String, isAnonymous: Bool, dateCreated: Date) {
        self.userId = userId
        self.isAnonymous = isAnonymous
        self.dateCreated = dateCreated
    }
    
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.isAnonymous = try container.decode(Bool.self, forKey: .isAnonymous)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.isAnonymous, forKey: .isAnonymous)
        try container.encode(self.dateCreated, forKey: .dateCreated)
    }
    
}
