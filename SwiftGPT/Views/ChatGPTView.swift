//
//  ChatGPTView.swift
//  SwiftGPT
//
//  Created by mbabicz on 25/01/2023.
//

import SwiftUI

struct ChatGPTView: View {
    @StateObject var viewModel = GPTViewModel()
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                messagesView
                MessageInputArea(
                    text: $viewModel.typingMessage,
                    placeholder: L10n.Message.Textfield.placeholder,
                    onSend: viewModel.sendMessage,
                    isFocusedBinding: $isFocused
                )
            }
            .background(.appBackground)
            .onTapGesture { isFocused = false }
            .navigationTitle(L10n.Chatgpt.Tab.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Private Views
    private var messagesView: some View {
        Group {
            if viewModel.messages.isEmpty {
                emptyStateView
            } else {
                messagesScrollView
            }
        }
    }

    private var messagesScrollView: some View {
        ScrollViewReader { reader in
            ScrollView {
                ForEach(viewModel.messages) { message in
                    MessageView(message: message)
                }
                Text("").id(viewModel.bottomID)
            }
            .onChange(of: viewModel.messages.count) { _ in
                withAnimation { reader.scrollTo(viewModel.bottomID) }
            }
            .onAppear { withAnimation { reader.scrollTo(viewModel.bottomID) } }
        }
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemSymbol: .ellipsisBubble)
                .font(.largeTitle)
            Text(L10n.Chat.Introduce.title)
                .font(.subheadline)
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
