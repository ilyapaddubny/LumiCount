//
//  ContentView.swift
//  SwiftCount
//
//  Created by Ilya Paddubny on 15.06.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RootView: View {
    @State private var shouldRefresh = false
    @StateObject private var viewModel = RootViewViewModel()
    
    var body: some View {
        
        ZStack {
            NavigationStack {
                GoalListView(refresh: $shouldRefresh)
            }
            .environment(\.colorScheme, .light)
        }
        .alert(isPresented: $viewModel.alert) {
            Alert(
                title: Text(Constants.Strings.alertTitle),
                message: Text(viewModel.alertDescription),
                dismissButton: .default(Text(Constants.Strings.alertDismissButton))
            )
        }
        .task {
            await viewModel.authentication()
            print("ℹ️ RootView refresh toggle")
            shouldRefresh.toggle()
        }
        
    }
    
    private struct Constants {
        struct Strings {
            static let alertTitle = "Error"
            static let alertMessage = "" //TODO: add alert logic here
            static let alertDismissButton = "OK"
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
