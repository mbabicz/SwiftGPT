//
//  ChatBotView.swift
//  OpenAI GPT-DALL-E
//
//  Created by kz on 25/01/2023.
//

import SwiftUI

struct ChatBotView: View {

    @ObservedObject var chatBotViewModel = OpenAIViewModel()
    @State var typingMessage: String = ""
    @Namespace var bottomID

    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                if !chatBotViewModel.gptMessages.isEmpty{
                    ScrollViewReader { reader in
                        ScrollView(.vertical) {
                            ForEach(chatBotViewModel.gptMessages.indices, id: \.self){ index in
                                let message = chatBotViewModel.gptMessages[index]
                                MessageView(message: message)
                            }
                            Text("").id(bottomID)
                        }
                        .onAppear{
                            withAnimation{
                                reader.scrollTo(bottomID)
                            }
                        }
                        .onChange(of: chatBotViewModel.gptMessages.count){ _ in
                            withAnimation{
                                reader.scrollTo(bottomID)
                            }
                        }
                    }
                } else {
                    VStack{
                        Image(systemName: "ellipses.bubble")
                            .font(.largeTitle)
                        Text("Write your first message!")
                            .font(.subheadline)
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                HStack(alignment: .center){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .padding()
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Button {
                        if self.typingMessage != "" {
                            chatBotViewModel.getGPTResponse(text: self.typingMessage)
                            self.typingMessage = ""
                        }
                    } label: {
                        Image(systemName: typingMessage == "" ? "circle" : "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(typingMessage == "" ? .white.opacity(0.75) : .white)
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
        }
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}
