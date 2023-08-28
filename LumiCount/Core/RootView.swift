//
//  ContentView.swift
//  SwiftCount
//
//  Created by Ilya Paddubny on 15.06.2023.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var viewModel = RootViewViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                GoalListView()
            }
            .environment(\.colorScheme, .light)
        }
        .alert(isPresented: $viewModel.alert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.alertDescription),
                dismissButton: .default(Text("OK"))
            )
        }
        .task {
            await viewModel.Authentication()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
