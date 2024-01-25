//
//  DropViewDelegate.swift
//  CountMate
//
//  Created by Ilya Paddubny on 02.07.2023.
//

import SwiftUI

struct DropViewDelegete: DropDelegate {
    var goal: Goal
    var goalData: GoalListViewViewModel
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    // User dragged into a new goal
    func dropEntered(info: DropInfo) {
        
        // From index
        let fromIndex = goalData.goals.firstIndex { (goal) -> Bool in
            return goal.id == goalData.draggingGoal?.id
        } ?? 0
        
        // To index
        let toIndex = goalData.goals.firstIndex { (goal) -> Bool in
            return goal.id == self.goal.id
        } ?? 0
        
        // Safety check
        if fromIndex != toIndex {
            // Swapping data
            withAnimation {
                var fromGoal = goalData.goals[fromIndex]
                goalData.goals[fromIndex] = goalData.goals[toIndex]
                goalData.goals[toIndex] = fromGoal
                
            }
            
        }
    }
    
    // Setting action to .move
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
}
