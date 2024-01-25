//
//  CMButton.swift
//  CountMate
//
//  Created by Ilya Paddubny on 26.05.2023.
//

import SwiftUI

struct CMButton: View {
    let color: Color
    let lable: String
    let action: () -> Void
    
    var body: some View {
        
        Button (action: action) {
                ZStack {
                    Rectangle()
                        .foregroundColor(color)
                        .frame(height: 43)
                    Text(lable)
                        .foregroundColor(Color.white)
                }
            }
    }
}

struct CMButton_Previews: PreviewProvider {
    static var previews: some View {
        CMButton(color: Color.gray, lable: "Lable"){
            
        }
    }
}
