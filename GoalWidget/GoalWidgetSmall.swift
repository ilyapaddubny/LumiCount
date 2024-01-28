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
        return GoalEntry(configuration: ConfigurationAppIntent(), goal: Goal(title: Constants.title,
                                                                              aim: 10,
                                                                              step: 1,
                                                                              currentNumber: 2,
                                                                              color: "CustomOrange"))
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> GoalEntry {
        
        let goalToPreview = UserDefaults(suiteName: "group.Paddubny.LumiCount")?.goals(forKey: "goals").first ??
        Goal(title: Constants.title,
             aim: 10,
             step: 1,
             currentNumber: 2,
             color: "CustomOrange")
        
        if context.isPreview {
            return GoalEntry(configuration: configuration, goal: goalToPreview)
        } else {
            return GoalEntry(configuration: configuration, goal: configuration.goal)
        }
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<GoalEntry> {
        return Timeline(entries:  [GoalEntry(configuration: configuration, goal: configuration.goal)], policy: .atEnd)
    }
    
    private struct Constants {
        static let title = "Gym visits"
    }
}



struct GoalWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    private var titleText: String {
            return entry.goal?.title ?? "Default name"
        }
    
    var body: some View {
        ZStack {
            Color(Constants.Strings.backgroundName)
            if entry.goal != nil {
                DynamicBacgroundView(backgroundColor: Color(entry.goal!.color),
                              size: CGSize(width: 1.0,
                                           height:( Double(entry.goal!.currentNumber) / Double(entry.goal!.aim))))
                
                smallWidgetViewContent
            }
            else {
                VStack {
                    Text(Constants.Strings.emptyPlaceholderHint)
                        .foregroundStyle(.black)
                }
                .padding()
            }
            
        }
    }
    
    private var smallWidgetViewContent: some View {
        VStack(alignment: .leading) {
            Text(titleText)
                .lineLimit(2)
                .font(.system(size: 18))
            Spacer()
            HStack(alignment: .bottom) {
                currentCountText
                Spacer()
                addStepButton
            }
        }
        .foregroundColor(Color.black)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
    
    private var addStepButton: some View {
        Button(intent: AddStepIntent(step: entry.goal!.step, id: entry.goal!.id)) {
            Image(systemName: "plus")
                .font(.system(size: 26))
                .padding(.horizontal, 14)
                .padding(.vertical, 4)
                .background {
                    RoundedRectangle(cornerSize: CGSize(width: 100, height: 100))
                        .foregroundStyle(.white)
                }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var currentCountText: some View {
        Text("\(entry.goal!.currentNumber)")
            .lineLimit(1)
            .font(.custom(Constants.Strings.goalName, size: Constants.mediumTextSize))
            .contentTransition(.numericText())
            .animation(.spring(duration: 0.2), value: entry.goal?.currentNumber)
            .invalidatableContent()
    }
}



private struct Constants {
    static let cornerRadius = 15.0
    static let tileHeight = 170.0
    static let buttonOffset = -12.5
    
    static let mediumTextSize = 22.0
    static let smallTextSize = 18.0
    
    
    struct Strings {
        static let step = "Step"
        static let goalName = "Goals"
        static let backgroundName = "BackgroundPale"
        static let emptyPlaceholderHint = "Long press to edit widget and select the goal"
    }
}



struct GoalWidgetSmall: Widget {
    
    let kind: String = "GoalWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            GoalWidgetEntryView(entry: entry)
                .containerBackground(.fill
                    .tertiary, for: .widget)
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
    GoalEntry(configuration: .init(), goal: Goal( title: "This is a goal's title",
                                                 aim: 100,
                                                 step: 10,
                                                 currentNumber: 20,
                                                 color: "CustomRed"))
    
    GoalEntry(configuration: .init(), goal: Goal(title: "This is a goal's title",
                                                 aim: 100,
                                                 step: 10,
                                                 currentNumber: 20,
                                                 color: "CustomRed"))
}

