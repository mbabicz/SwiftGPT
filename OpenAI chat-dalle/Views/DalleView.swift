//
//  DalleView.swift
//  OpenAI GPT-DALL-E
//
//  Created by kz on 06/02/2023.
//

import SwiftUI

struct DalleView: View {
    
    @State var typingMessage: String = ""
    @ObservedObject var dalleViewModel = DalleViewModel()
    @Namespace var bottomID
    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                if !dalleViewModel.messages.isEmpty{
                    ScrollViewReader { reader in
                        ScrollView(.vertical) {
                            ForEach(dalleViewModel.messages.indices, id: \.self){ index in
                                let message = dalleViewModel.messages[index]
                                MessageView(message: message)
                            }
                            Text("").id(bottomID)
                        }
                        .onAppear{
                            withAnimation{
                                reader.scrollTo(bottomID)
                            }
                        }
                        .onChange(of: dalleViewModel.messages.count){ _ in
                            withAnimation{
                                reader.scrollTo(bottomID)
                            }
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "paintbrush")
                            .font(.largeTitle)
                        Text("Write your first message!")
                            .font(.subheadline)
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                HStack(alignment: .center){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .focused($fieldIsFocused)
                        .padding()
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onTapGesture {
                            fieldIsFocused = true
                        }
                    Button(action: sendMessage) {
                        Image(systemName: typingMessage.isEmpty ? "circle" : "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(typingMessage.isEmpty ? .white.opacity(0.75) : .white)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                }
                .onDisappear {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
                .cornerRadius(12)
                .padding([.leading, .trailing, .bottom], 10)
                .shadow(color: .black, radius: 0.5)
            }
            .background(Color(red: 53/255, green: 54/255, blue: 65/255))
            .gesture(TapGesture().onEnded {
                hideKeyboard()
            })
            .navigationTitle("DALL·E 2")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        Task{
            if !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty{
                let tempMessage = typingMessage
                typingMessage = ""
                hideKeyboard()
                await dalleViewModel.generateImage(prompt: tempMessage)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
