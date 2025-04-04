//
//  MessageInputArea.swift
//  SwiftGPT
//
//  Created by Michał Babicz on 04/04/2025.
//

import SwiftUI

struct MessageInputArea: View {
    @Binding var text: String
    var placeholder: String
    var onSend: () -> Void
    var isSendEnabled: Bool = true
    var isFocusedBinding: FocusState<Bool>.Binding
    
    var body: some View {
        HStack(alignment: .center) {
            TextField(placeholder, text: $text, axis: .vertical)
                .focused(isFocusedBinding)
                .padding()
                .foregroundStyle(.white)
                .lineLimit(3)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.alphabet)

            Button(action: {
                isFocusedBinding.wrappedValue = false
                onSend()
            }) {
                Image(systemSymbol: text.isEmpty ? .circle : .paperplaneFill)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(text.isEmpty ? .white.opacity(0.75) : .white)
                    .frame(width: 20, height: 20)
                    .padding()
            }
            .disabled(!isSendEnabled)
        }
        .background(.textFieldBackground)
        .cornerRadius(12)
        .padding([.leading, .trailing, .bottom], 10)
        .shadow(color: .black, radius: 0.5)
    }
}
