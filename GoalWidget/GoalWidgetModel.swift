//
//  GoalWidgetModel.swift
//  GoalWidgetExtension
//
//  Created by Ilya Paddubny on 23.11.2023.
//

import Foundation

class GoalWidgetModel {
    let selectedGoalID = ""
    var widgetGoal = Goal(title: "This is a goal's title",
                          aim: 100,
                          step: 10,
                          currentNumber: 20,
                          color: "CustomRed")
    

    
    
    func getWidgetGoal() -> Goal {
//        let orderedGoalsQuery = getGoalsQuery(orderBy: Constants.orderField)
        //TODO: add implimitation of a call to server
        
        return Goal(title: "This is a goal's title",
                    aim: 100,
                    step: 10,
                    currentNumber: 20,
                    color: "CustomRed")
    }
    

    
    private struct Constants {
        static let orderField = "array_index"
        static let userCollection = "users"
        static let goalCollection = "goals"

    }
}


