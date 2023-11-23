//
//  AppIntent.swift
//  GoalWidget
//
//  Created by Ilya Paddubny on 23.11.2023.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Chosen goal", default: "Name of goal")
    var goalName: String
}
