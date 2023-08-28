//
//  CustomFormLineView.swift
//  LumiCount
//
//  Created by Ilya Paddubny on 19.08.2023.
//

import SwiftUI



struct CustomFormLineView<ViewModel: ViewModelProtocol>: View {
    
    var viewModel: ViewModel
    let propertyName: Text
    let propertyValue: Binding<String>
    let field: FieldsError?
    
    init(viewModel: ViewModel, propertyName: Text, propertyValue: Binding<String>, field: FieldsError?) {
        self.viewModel = viewModel
        self.propertyName = propertyName
        self.propertyValue = propertyValue
        self.field = field
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                propertyName.black18()
                Spacer()
                TextField("Enter value", text: propertyValue)
                    .rightAlignment()
            }
            .frame(height: viewModel.fieldHeight)
            
            if let field = field {
                if let errorText = errorTextForField(field) {
                    HStack {
                        Text(errorText)
                            .redRegular(size: 14)
                        Spacer()
                    }
                    .frame(height: viewModel.extraFieldHeight)
                }
            }
        }
    }
    
    private func errorTextForField(_ field: FieldsError) -> String? {
        switch field {
        case .emptyTitle:
            return !viewModel.errorTitle.isEmpty ? viewModel.errorTitle : nil
        case .zeroAim:
            return !viewModel.errorAim.isEmpty ? viewModel.errorAim : nil
        case .zeroStep:
            return !viewModel.errorStep.isEmpty ? viewModel.errorStep : nil
        }
    }
}

