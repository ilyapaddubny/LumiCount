//
//  GoalWidget.swift
//  GoalWidget
//
//  Created by Ilya Paddubny on 23.11.2023.
//

import WidgetKit
import SwiftUI
import Firebase


struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> GoalEntry {
        return GoalEntry(configuration: ConfigurationAppIntent(), goal: Goal(id: UUID(),
                                                                 title: "dammy date",
                                                                 aim: 100,
                                                                 step: 10,
                                                                 currentNumber: 20,
                                                                 color: "red",
                                                                 arrayIndex: 0))
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> GoalEntry {
        GoalEntry(configuration: configuration, goal: Goal(id: UUID(),
                                                           title: "dammy date",
                                                           aim: 100,
                                                           step: 10,
                                                           currentNumber: 20,
                                                           color: "red",
                                                           arrayIndex: 0))
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<GoalEntry> {
        //TODO: fetch data here
        var viewModel = GoalWidgetModel()
        return Timeline(entries:  [GoalEntry(configuration: ConfigurationAppIntent(), goal: Goal(id: UUID(),
                                                                                     title: "dammy date",
                                                                                     aim: 100,
                                                                                     step: 10,
                                                                                     currentNumber: 20,
                                                                                     color: "red",
                                                                                     arrayIndex: 0))], policy: .atEnd)
    }
}



struct GoalWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    var body: some View {
        ZStack {
            Color.yellow
            
            VStack() {
                Text(entry.goal?.title ?? "goalName")
                    .lineLimit(2)
                    .foregroundColor(Color.black)
                Spacer()
                HStack{
                    Text("\(entry.goal?.currentNumber ?? 00) / \(entry.goal?.aim ?? 00)")
                }
                .foregroundColor(Color.black)
                .font(.custom(Constants.Strings.goalName, size: Constants.mediumTextSize))
                Spacer()
//                Spacer()
//                Text("\(Constants.Strings.step) \(entry.goal.step)")
//                    .foregroundColor(Color.black)
                Button(intent: AddStepIntent(step: 10, id: "809DEB49-7D9F-4012-AFEE-EE9921101847")) {
                    Label("10", systemImage: "plus")
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        }
        
    }
    
    private struct Constants {
        static let cornerRadius = 15.0
        static let tileHeight = 170.0
        static let buttonOffset = -12.5
        
        static let mediumTextSize = 22.0
        static let smallTextSize = 16.0
        
        
        struct Strings {
            static let step = "Step"
            static let goalName = "Goals"
            static let alertTitle = "Error"
            static let alertMessage = "" //TODO: add alert logic here
            static let alertDismissButton = "OK"
        }
    }
}


struct GoalWidgetSmall: Widget {
    init() {
        FirebaseApp.configure()
    }

    
    let kind: String = "GoalWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            GoalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        } 
        .configurationDisplayName("Goal Widget")
        .description("Goas's interactive widget.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}


#Preview(as: .systemSmall) {
    GoalWidgetSmall()
} timeline: {
    GoalEntry(configuration: .init(), goal: Goal(id: UUID(),
                                                   title: "This is a goal's title",
                                                   aim: 100,
                                                   step: 10,
                                                   currentNumber: 20,
                                                   color: "red",
                                                   arrayIndex: 0))
    
    GoalEntry(configuration: .init(), goal: Goal(id: UUID(),
                                                      title: "This is a goal's title",
                                                      aim: 100,
                                                      step: 10,
                                                      currentNumber: 20,
                                                      color: "red",
                                                      arrayIndex: 0))
}
