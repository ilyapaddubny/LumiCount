//
//  GoalWidgetModel.swift
//  GoalWidgetExtension
//
//  Created by Ilya Paddubny on 23.11.2023.
//

import Foundation

class GoalWidgetModel {
    let selectedGoalID = ""
    var widgetGoal = Goal(id: UUID(),
                          title: "This is a goal's title",
                          aim: 100,
                          step: 10,
                          currentNumber: 20,
                          color: "CustomRed",
                          arrayIndex: 0)
    

    
    
    func getWidgetGoal() -> Goal {
//        let orderedGoalsQuery = getGoalsQuery(orderBy: Constants.orderField)
        //TODO: add implimitation of a call to server
        
        return Goal(id: UUID(),
                    title: "This is a goal's title",
                    aim: 100,
                    step: 10,
                    currentNumber: 20,
                    color: "CustomRed",
                    arrayIndex: 0)
    }
    

    
    private struct Constants {
        static let orderField = "array_index"
        static let userCollection = "users"
        static let goalCollection = "goals"

    }
}


