//
//  SwiftCountApp.swift
//  SwiftCount
//
//  Created by Ilya Paddubny on 15.06.2023.
//

import SwiftUI
import WidgetKit

@main
struct LumiCount: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                GoalListView(viewModel: GoalListViewViewModel())
                    .preferredColorScheme(.light)
            }
            .onChange(of: scenePhase) { newScenePhase in
                if newScenePhase == .background || newScenePhase == .inactive {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
    }
}

