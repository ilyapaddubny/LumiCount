//
//  CustomSecureField.swift
//  CountMate
//
//  Created by Ilya Paddubny on 26.05.2023.
//

import SwiftUI

// Used to change the color of placeholder in SecureField
struct CustomSecureField: View {
    var placeholder: Text
    @Binding var text: String
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder}
            SecureField("", text: $text, onCommit: commit)
                .font(.system(size: 18))
        }
    }
    
}

struct CustomSecureField_Previews: PreviewProvider {
    static var previews: some View {
        CustomSecureField(placeholder: Text("Some text"), text: .constant("Some text")) {
            
        }
    }
}
