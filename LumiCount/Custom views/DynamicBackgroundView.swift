//
//  BacgroundView.swift
//  Simple counter
//
//  Created by Ilya Paddubny on 01.04.2023.
//

import SwiftUI

struct DynamicBacgroundView: View {
    var backgroundColor: Color
    var size: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer(minLength: 0) //minLength: 0 in order to let Rectangle to fill the entyre space
                Rectangle()
                    .background{
                        Color.white
                    }
                    .foregroundStyle(LinearGradient(colors: [backgroundColor.opacity(0.8), backgroundColor.opacity(1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: geometry.size.width, height: geometry.size.height * size.height)
                    .animation(.default, value: size)
            }
        }
    }
}


struct DynamicBacgroundView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicBacgroundView(backgroundColor: Color.black, size: CGSize.zero)
    }
}
