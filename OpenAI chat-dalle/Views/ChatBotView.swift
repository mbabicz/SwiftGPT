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
    @State var models = [String]()
    @Namespace var bottomID
    
    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                ScrollViewReader { reader in
                    ScrollView(.vertical) {
                        ForEach(models, id: \.self) { message in
                            HStack {
                                if message.contains("Me: ") {
                                    MessageView(message: message.replacingOccurrences(of: "Me: ", with: ""), isUserMessage: true, isBotMessage: false)
                                } else if message.contains("ChatBot: ") {
                                    MessageView(message: message.replacingOccurrences(of: "ChatBot: ", with: "").trimmingCharacters(in: .whitespacesAndNewlines), isUserMessage: false, isBotMessage: true)
                                } else {
                                    MessageIndicatorView()
                                    Spacer()
                                }
                            }
                        }
                        Text("").id(bottomID)
                    }
                    
                    .onAppear{
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                    .onChange(of: models.count){ _ in
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
                        send()
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
    
    func send() {
        guard !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty,
            models.isEmpty || models.last != "Me: \(typingMessage)" else {
            return
        }
        models.append("Me: \(typingMessage)")
        models.append("Waiting:")

        botVM.send(text: typingMessage) { response in
            DispatchQueue.main.async {
                self.models.removeLast()
                self.models.append("ChatBot: \(response)")
            }
        }
    }
}

struct ChatGPTView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBotView()
    }
}
