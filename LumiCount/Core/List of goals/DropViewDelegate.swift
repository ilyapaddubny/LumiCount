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
        updateFirebase()
        return true
    }
    
    // User dragged into a new goal
    func dropEntered(info: DropInfo) {
        
        // Getting from and to Index
        
        // From index
        let fromIndex = goalData.items.firstIndex { (goal) -> Bool in
            return goal.id == goalData.draggingGoal?.id
        } ?? 0
        
        // To index
        let toIndex = goalData.items.firstIndex { (goal) -> Bool in
            return goal.id == self.goal.id
        } ?? 0
        
        // Safe check
        if fromIndex != toIndex {
            // Swapping data
            withAnimation {
                var fromGoal = goalData.items[fromIndex]
                
                goalData.items[fromIndex].arrayIndex = goalData.items[toIndex].arrayIndex
                goalData.items[toIndex].arrayIndex = fromGoal.arrayIndex
                fromGoal.arrayIndex = goalData.items[fromIndex].arrayIndex
                
                goalData.items[fromIndex] = goalData.items[toIndex]
                goalData.items[toIndex] = fromGoal
                
            }
            
        }
    }
    
    // Setting action to .move
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    // Used to Update the order of [goal] in Firebase. For this purpose goal.arrayIndex was used
    func updateFirebase() {
        Task {
            do {
                try await goalData.updateGoalsArray()
            } catch {
                print("ℹ️" + error.localizedDescription)
            }
            
        }
        
    }
    
    
}
