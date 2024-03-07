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
        NavigationView {
            GeometryReader { _ in
                Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1)
                    .contentShape(Rectangle())
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    messagesView
                    inputArea
                }
                .background(Color(red: 53/255, green: 54/255, blue: 65/255))
                .onTapGesture { isFocused = false }
                .navigationTitle("GPT 3.5 Turbo")
                .navigationBarTitleDisplayMode(.inline)
            }
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

    private var inputArea: some View {
        HStack(alignment: .center) {
            TextField("Message...", text: $viewModel.typingMessage)
                .focused($isFocused)
                .padding()
                .foregroundColor(.white)
                .lineLimit(3)
                .disableAutocorrection(true)
                .autocapitalization(.none)

            Button(action: {
                self.isFocused = false
                viewModel.sendMessage()
            }) {
                Image(systemName: viewModel.typingMessage.isEmpty ? "circle" : "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(viewModel.typingMessage.isEmpty ? .white.opacity(0.75) : .white)
                    .frame(width: 20, height: 20)
                    .padding()
            }
        }
        .background(Color(red: 63/255, green: 66/255, blue: 78/255))
        .cornerRadius(12)
        .padding([.leading, .trailing, .bottom], 10)
        .shadow(color: .black, radius: 0.5)
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemName: "ellipses.bubble")
                .font(.largeTitle)
            Text("Write your first message!")
                .font(.subheadline)
                .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
