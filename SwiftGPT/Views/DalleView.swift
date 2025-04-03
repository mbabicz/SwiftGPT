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

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                messagesView
                inputArea
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

    private var inputArea: some View {
        HStack(alignment: .center) {
            TextField(L10n.Message.Textfield.placeholder, text: $viewModel.typingMessage, axis: .vertical)
                .focused($isFocused)
                .padding()
                .foregroundStyle(.white)
                .lineLimit(3)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.alphabet)

            Button(action: viewModel.sendMessage) {
                Image(systemSymbol: viewModel.typingMessage.isEmpty ? .circle : .paperplaneFill)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(viewModel.typingMessage.isEmpty ? .white.opacity(0.75) : .white)
                    .frame(width: 20, height: 20)
                    .padding()
            }
        }
        .background(.textFieldBackground)
        .cornerRadius(12)
        .padding([.leading, .trailing, .bottom], 10)
        .shadow(color: .black, radius: 0.5)
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
