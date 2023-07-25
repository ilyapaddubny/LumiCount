//
//  CustomTextField.swift
//  CountMate
//
//  Created by Ilya Paddubny on 26.05.2023.
//

import SwiftUI

// Used to change the color of placeholder in SecureField
struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
                .font(.custom("LeagueSpartan-Regular", size: 18))
        }
    }
    
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: Text(""), text: .constant("text")) { True in
            
        } commit: {
            
        }

    }
}



