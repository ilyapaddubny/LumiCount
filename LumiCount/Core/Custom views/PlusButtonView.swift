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
                .frame(width: 70, height: 70)
                .overlay(
                    Button(action: {
                        feedbackGenerator.impactOccurred()
                        action()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.custom("", size: 50))
                    }
                )
        }
        
    }
}

struct PlusButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PlusButtonView() {
        }
    }
}
