//
//  GoalListView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 01.06.2023.
//

import FirebaseFirestoreSwift
import SwiftUI
struct GoalListView: View {
    @Binding var refresh: Bool
    @StateObject var viewModel = GoalListViewViewModel()
    @State private var showToolbarItem = false
    
    
    @State private var size = CGSize(width: 0, height: 0)
    @State var selectedColor: Color = .customRed
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            background
            if viewModel.items.isEmpty {
                emptyPage
            } else {
                goals
            }
        }
        //TODO: deal deprecated
        .onChange(of: refresh, perform: { newValue in
            if newValue {
                viewModel.initializeItems()
                refresh = false
                showToolbarItem = true
                print("ℹ️ GoalListView refreshed")
            }
        })
        .alert(isPresented: $viewModel.alert) { //TODO: deal deprecated
            Alert(
                title: Text(Constants.Strings.alertTitle),
                message: Text(viewModel.alertDescription),
                dismissButton: .default(Text(Constants.Strings.alertDismissButton))
            )
        }
        .navigationTitle(Constants.Strings.navBarTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if showToolbarItem {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: NewGoalView(uid: viewModel.uid)) {
                        Image(systemName: Constants.Strings.plus)
                    }
                }
            }
        }.accentColor(Color.black)
        
    }
    
    var background: some View {
        LinearGradient (
            gradient: Gradient(colors: [Color.backgroundTop, Color.backgroundBottom]),
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
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
            Text("image: Flaticon.com")
                .blackExtraLight(size: 14)
                .multilineTextAlignment(.leading)
                .padding()
        }
    }
    
    var goals: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: SettingsView(goal: item)) {
                        GoalItemView(goal: item)
                            .onDrag {
                                viewModel.draggingGoal = item
                                // Sending ID for sample
                                return NSItemProvider(contentsOf: URL(string: "\(item.id)")!)!
                            }
                            .onDrop(of: [.url], delegate: DropViewDelegete(goal: item,
                                                                           goalData: viewModel))
                    }
                }
            }
            .padding()
        }
    }
    
    private struct Constants {
        struct Strings {
            static let plus = "plus"
            static let navBarTitle = "Goals"
            static let alertTitle = "Error"
            static let alertMessage = "" //TODO: add alert logic here
            static let alertDismissButton = "OK"
        }
    }
}

struct GoalListView_Previews: PreviewProvider {
    static var previews: some View {
        GoalListView(refresh: .constant(false))
    }
}
