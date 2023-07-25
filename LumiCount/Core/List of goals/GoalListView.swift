//
//  GoalListView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 01.06.2023.
//

import FirebaseFirestoreSwift
import SwiftUI

struct GoalListView: View {
    
    @StateObject var viewModel = GoalListViewViewModel()
    
    @State private var size = CGSize(width: 0, height: 0)
    @State var selectedColor: Color = .customRed
    
    //    @State private var path = NavigationPath()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            LinearGradient (
                gradient: Gradient(colors: [Color.backgroundTop, Color.backgroundBottom]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            //            23/07
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.items) { item in
                        GoalItemView(goal: item)
                        // Drag and drop
                            .onDrag {
                                // Setting current goal
                                viewModel.draggingGoal = item

                                // Sending ID for sample
                                return NSItemProvider(contentsOf: URL(string: "\(item.id)")!)!
                            }
                            .onDrop(of: [.url], delegate: DropViewDelegete(goal: item,
                                                                           goalData: viewModel))
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("Goals", displayMode: .inline)
        //            23/07
        
                .toolbar {
        //            ToolbarItem(placement: .navigationBarLeading) {
        //                NavigationLink(destination: ProfileView()) {
        //                    Image(systemName: "info.circle")
        //                }
        //            }
        //
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: NewGoalView(uid: viewModel.uid)) {
                            Image(systemName: "plus")
                        }
                    }
                }
        
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView()
    }
}
