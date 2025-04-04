//
//  DalleView.swift
//  SwiftGPT
//
//  Created by mbabicz on 06/02/2023.
//

import SwiftUI

struct DalleView: View {
    @StateObject var viewModel = DalleViewModel()
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
            .navigationTitle(L10n.Dalle.Tab.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Message Views
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
                ForEach(viewModel.messages.indices, id: \.self) { index in
                    MessageView(message: viewModel.messages[index])
                }
                Text("").id(viewModel.bottomID)
            }
            .onAppear {
                scrollToBottom(with: reader)
            }
            .onChange(of: viewModel.messages.count) { _ in
                scrollToBottom(with: reader)
            }
        }
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemSymbol: .paintbrush)
                .font(.largeTitle)
            Text(L10n.Chat.Introduce.title)
                .font(.subheadline)
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func scrollToBottom(with reader: ScrollViewProxy) {
        withAnimation {
            reader.scrollTo(viewModel.bottomID, anchor: .bottom)
        }
    }
}
