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
        GoalEntry(configuration: configuration, goal: configuration.goal)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<GoalEntry> {
        //TODO: fetch data here
        var viewModel = GoalWidgetModel()
        return Timeline(entries:  [GoalEntry(configuration: ConfigurationAppIntent(), goal: configuration.goal)], policy: .atEnd)
    }
}



struct GoalWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    var body: some View {
        ZStack {
            Color("BackgroundPale")
            BacgroundView(backgroundColor: Color(entry.goal?.color ?? ""),
                          size: CGSize(width: 1.0,
                                       height: ( Double(entry.goal?.currentNumber ?? 1) / Double(entry.goal?.aim ?? 1)) ))
            
            
            VStack() {
                Text(entry.goal?.title ?? "goalName")
                    .lineLimit(2)
                    .foregroundColor(Color.black)
                Spacer()
                HStack{
                    Text("\(entry.goal?.currentNumber ?? 00) / \(entry.goal?.aim ?? 00)")
                        .invalidatableContent()

                }
                .foregroundColor(Color.black)
                .font(.custom(Constants.Strings.goalName, size: Constants.mediumTextSize))
                Spacer()
                Spacer()
                Button(intent: AddStepIntent(step: 10, id: entry.goal?.id.uuidString ?? "")) {
                    Text("+ \(entry.goal?.step ?? 0)")
                        .foregroundStyle(.black)
                        .font(.system(size: 22))
                        .padding(.horizontal, 15)
                        .padding(.vertical, 4)
                        .background{
                            RoundedRectangle(cornerSize: CGSize(width: 100, height: 100))
                                .foregroundStyle(LinearGradient(colors: [.gray.opacity(0.25), .gray.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                        }
                }.buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
        }
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

