//
//  ExampleGoalRowView.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 24.08.2023.
//

import SwiftUI

struct ExampleGoalRowView: View {
    var title: String
    var circleColor: String
    let height: CGFloat
    var onTapAction: () -> Void // A closure to perform the action
    
    
    var body: some View {
        HStack() {
            Text(title)
            Spacer()
            Circle()
                .fill(Color(circleColor))
                .frame(width: 30, height: 30)
        }
        .padding([.leading, .trailing])
        .frame(height: height)
        .contentShape(Rectangle())
        .onTapGesture {
            onTapAction()
        }
    }
}

struct ExampleGoalRowView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleGoalRowView(title: "", circleColor: "", height: 8, onTapAction: {})
    }
}
