//
//  GoalListView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 01.06.2023.
//

import SwiftUI
import ConfettiSwiftUI

struct GoalListView: View {
    @ObservedObject var viewModel: GoalListViewViewModel
    @State private var size = CGSize(width: 0, height: 0)
    @State var selectedColor: Color = .customRed
    @State var editViewIsPresented = false 
    @State var settingsMode: SettingsMode = .edit
    @State var confettiTrigger = 0
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            background
            if viewModel.goals.isEmpty {
                emptyPage
            } else {
                goals
                    .confettiCannon(counter: $confettiTrigger, num: 60 , confettiSize: 13, rainHeight: 300, radius: 500)
            }
        }
        .navigationTitle(Constants.Strings.navBarTitle)
        .toolbar {
            Button {
                viewModel.insert(Goal(title: "", aim: 1, step: 1, currentNumber: 0, color: "CustomBlueAqua"))
                settingsMode = .new
                editViewIsPresented = true
            } label: {
                Image(systemName: "plus")
                    .tint(.black)
            }
        }
        .sheet(isPresented: $editViewIsPresented) {
            NavigationStack {
                SettingsView(goal: $viewModel.goals[viewModel.cursorIndex],
                             mode: settingsMode,
                             deleteAction: { id in
                    viewModel.deleteGoal(id: id)
                })
                .navigationTitle(settingsMode == SettingsMode.edit ? Constants.Strings.navBarTitleEditGoal : Constants.Strings.navBarTitleNewGoal)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            editViewIsPresented = false
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "chevron.left")
                                    .aspectRatio(contentMode: .fit)
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Goals")
                            }
                           
                        }
                    }
                    //TODO: Add a toolbarItem, but looks like it doesn't work well with .sheet
//                    ToolbarItemGroup(placement: .keyboard) {
//                        HStack {
//                            Spacer()
//                            Button("Done") {
//                                print("do something")
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
                }
            }
        }
    }
    
    var goals: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.goals) { item in
                    
                    GoalItemView (goal: item, 
                                  action: {
                        viewModel.addStep(goalID: item.id)
                    },
                    confettiTrigger: $confettiTrigger)
                        .onDrag {
                            viewModel.draggingGoal = item
                            // Sending ID for sample
                            return NSItemProvider(contentsOf: URL(string: "\(item.id)")!)!
                        }
                        .onDrop(of: [.url], delegate: DropViewDelegete(goal: item,
                                                                       goalData: viewModel))
                        .onTapGesture {
                            if let index = viewModel.goals.firstIndex(where: {$0.id == item.id}) {
                                viewModel.cursorIndex = index
                                settingsMode = .edit
                                editViewIsPresented = true
                            }
                        }
                }
            }
            .padding()
        }
    }
    
    var emptyPage: some View {
        VStack(alignment: .center) {
            Spacer()
            Image("empty_folder")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
                .padding()
            Text("List of goals is empty")
                .blackExtraLight(size: 40)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
            Spacer()
            Spacer()
            Text("icon: Flaticon.com")
                .blackExtraLight(size: 14)
                .multilineTextAlignment(.leading)
                .padding()
        }
    }
    
    var background: some View {
        LinearGradient (
            gradient: Gradient(colors: [Color.backgroundTop, Color.backgroundBottom]),
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
    }
    
    private struct Constants {
        struct Strings {
            static let plus = "plus"
            static let navBarTitle = "Goals"
            static let navBarTitleEditGoal = "EDIT GOAL"
            static let navBarTitleNewGoal = "NEW GOAL"
            static let alertTitle = "Error"
            static let alertMessage = "" //TODO: add alert logic here
            static let alertDismissButton = "OK"
        }
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView(viewModel: GoalListViewViewModel())
    }
}
