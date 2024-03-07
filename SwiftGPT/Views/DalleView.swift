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
                .navigationTitle("DALL·E 2")
                .navigationBarTitleDisplayMode(.inline)
            }
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
        HStack(alignment: .center){
            TextField("Message...", text: $viewModel.typingMessage, axis: .vertical)
                .focused($isFocused)
                .padding()
                .foregroundColor(.white)
                .lineLimit(3)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.alphabet)
            
            Button(action: viewModel.sendMessage) {
                Image(systemName: viewModel.typingMessage.isEmpty ? "circle" : "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(viewModel.typingMessage.isEmpty ? .white.opacity(0.75) : .white)
                    .frame(width: 20, height: 20)
                    .padding()
            }
        }
        .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
        .cornerRadius(12)
        .padding([.leading, .trailing, .bottom], 10)
        .shadow(color: .black, radius: 0.5)
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "paintbrush")
                .font(.largeTitle)
            Text("Write your first message!")
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
