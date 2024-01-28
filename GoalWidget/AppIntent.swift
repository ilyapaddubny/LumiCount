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
    
//    A static property representing the title of the widget configuration
    static var title: LocalizedStringResource = "Configuration"
//    A static property representing the description of the widget configuration.
    static var description = IntentDescription("This is an example widget.")
//    Users can provide a goal when adding the widget to the home screen.
    @Parameter(title: "Goal")
    var goal: Goal?
    
    init(goal: Goal = Goal(title: "isPreview",
                           aim: 100,
                           step: 10,
                           currentNumber: 20,
                           color: "CustomRed")) {
            self.goal = goal
        }
        
        init() {
        }

}

//    Representing a single entry in the widget's timeline.
struct GoalEntry: TimelineEntry {
    let date = Date()
    let configuration: ConfigurationAppIntent 
//    The goal associated with this entry. This is the data that will be displayed in the widget.
    let goal: Goal?
}



