//
//  AppIntent.swift
//  GoalWidget
//
//  Created by Ilya Paddubny on 23.11.2023.
//

import Intents


import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
//    @Parameter(title: "Chosen goal")
//    var goalName: GoalEnum
}




struct GoalEntry: TimelineEntry {
    let date = Date()
    let configuration: ConfigurationAppIntent
    let goal: Goal?
}



