//
//  ChatBotView.swift
//  ChattingAPP
//
//  Created by kz on 25/01/2023.
//

import SwiftUI

struct ChatBotView: View {

    @ObservedObject var botVM = ChatBotViewModel()
    @State var typingMessage: String = ""
    @Namespace var bottomID

    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                ScrollViewReader { reader in
                    ScrollView(.vertical) {
                        if botVM.messages.count > 0{
                            ForEach(botVM.messages.indices, id: \.self){ index in
                                let message = botVM.messages[index]
                                MessageView(message: message)
                            }
                        }
                        Text("").id(bottomID)
                    }
                    .onAppear{
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                    .onChange(of: botVM.messages.count){ _ in
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                }
                
                HStack(alignment: .center){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .padding(12)
                        .font(.callout)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                    
                    Button {
                        botVM.getResponse(text: self.typingMessage)
                        self.typingMessage = ""
                        
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(45))
                            .font(.system(size: 34))
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("ChatBot")
        }
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}
