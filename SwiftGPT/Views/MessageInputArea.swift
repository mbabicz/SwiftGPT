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
                .padding(.appSpacingMD)
                .foregroundStyle(.white)
                .lineLimit(Config.UserInterface.textFieldMaxLines)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.alphabet)
                .accessibilityLabel(L10n.Accessibility.Textfield.message)

            Button {
                isFocusedBinding.wrappedValue = false
                onSend()
            } label: {
                Image(systemSymbol: text.isEmpty ? .circle : .paperplaneFill)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(text.isEmpty ? .white.opacity(0.75) : .white)
                    .frame(width: .appIconSM, height: .appIconSM)
                    .padding(.appSpacingMD)
            }
            .disabled(!isSendEnabled)
            .accessibilityLabel(L10n.Accessibility.Button.send)
            .accessibilityHint(L10n.Accessibility.Button.Send.hint)
        }
        .background(.textFieldBackground)
        .cornerRadius(Config.UserInterface.inputCornerRadius)
        .padding([.leading, .trailing, .bottom], .appSpacingSM)
        .appShadowSM()
    }
}
