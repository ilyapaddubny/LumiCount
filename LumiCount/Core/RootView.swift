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
        .onAppear(){
            Task{
                do {
                    try await viewModel.Authentication()
                } catch {
//                    TODO: deal with Error from RootViewViewModel.signIn()
                    print("❌ Error occurred while signing in:", error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
