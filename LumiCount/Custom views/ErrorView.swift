//
//  ErrorView.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 05.08.2023.
//

import SwiftUI

struct ErrorView: View {
    @State var color = Color.black.opacity(0.7)
    @Binding var alert: Bool
    @Binding var errorBody: String
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                HStack {
                    Text("Error")
                    Spacer()
                }
                
                Text(self.errorBody)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button("Cancel"){
                    alert = false
                }
                .buttonStyle(TintedButtonStyle(buttonColor: .red))
                .padding(.top, 25)
                
            }.frame(width: UIScreen.main.bounds.width - 70)
                .background(Color.white)
                .cornerRadius(15)
            
            
        }.background(Color.black.opacity(0.35).ignoresSafeArea())
    }
        
}

#Preview {
    ErrorView(alert: .constant(true), errorBody: .constant("Some error body text goes here."))
}
