//
//  SwiftCountApp.swift
//  SwiftCount
//
//  Created by Ilya Paddubny on 15.06.2023.
//

import SwiftUI

@main
struct LumiCount: App {
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GoalListView()
            }
            .preferredColorScheme(.light)
        }
    }
}

