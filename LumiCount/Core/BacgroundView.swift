//
//  BacgroundView.swift
//  Simple counter
//
//  Created by Ilya Paddubny on 01.04.2023.
//

import SwiftUI

struct BacgroundView: View {
    var backgroundColor: Color
    var size: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer(minLength: 0) //minLength: 0 in order to let Rectangle to fill the entyre screen
                Rectangle()
                    .foregroundColor(backgroundColor)
                    .frame(width: geometry.size.width, height: geometry.size.height * size.height)
                    .animation(.default, value: size)
            }
        }
    }
}


struct BacgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BacgroundView(backgroundColor: Color.black, size: CGSize.zero)
    }
}
