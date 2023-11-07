//
//  PlusButtonView.swift
//  CountMate
//
//  Created by Ilya Paddubny on 02.06.2023.
//

import SwiftUI

struct PlusButtonView: View {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
        feedbackGenerator.prepare()
    }
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.white)
                .frame(width: Constants.buttonHeight, height: Constants.buttonHeight)
                .overlay(
                    Button(action: {
                        feedbackGenerator.impactOccurred()
                        action()
                    }) {
                        Image(systemName: Constants.iconName)
                            .foregroundColor(.black)
                            .font(.custom("", size: Constants.iconSize))
                    }
                )
        }
        
    }
    
    private struct Constants {
        static let iconName = "plus"
        static let iconSize = 50.0
        static let buttonHeight = 70.0
    }
}

struct PlusButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PlusButtonView() {
        }
    }
}
