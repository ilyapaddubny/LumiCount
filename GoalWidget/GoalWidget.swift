//
//  GoalWidget.swift
//  GoalWidget
//
//  Created by Ilya Paddubny on 23.11.2023.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> GoalEntry {
        GoalEntry(configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> GoalEntry {
        GoalEntry(configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<GoalEntry> {
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.

        return Timeline(entries:  [GoalEntry(configuration: .read10Books)], policy: .atEnd)
    }
}

struct GoalEntry: TimelineEntry {
    let date = Date()
    let configuration: ConfigurationAppIntent
}

struct GoalWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            Text(entry.configuration.goalName)
        }
    }
}

struct GoalWidget: Widget {
    let kind: String = "GoalWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            GoalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        } 
        .configurationDisplayName("Goal Widget")
        .description("Goas's interactive widget.")
        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var gymVisit: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.goalName = "Go to gym"
        return intent
    }
    
    fileprivate static var read10Books: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.goalName = "Read 10 books"
        return intent
    }
}

#Preview(as: .systemSmall) {
    GoalWidget()
} timeline: {
    GoalEntry(configuration: .gymVisit)
    GoalEntry(configuration: .read10Books)
}
