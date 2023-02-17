//
//  DalleView.swift
//  OpenAI GPT-DALL-E
//
//  Created by kz on 06/02/2023.
//

import SwiftUI

struct DalleView: View {
    @State var typingMessage: String = ""
    @ObservedObject var dalleVM = DalleViewModel()
    @Namespace var bottomID

    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                ScrollViewReader { reader in
                    ScrollView(.vertical) {
                        if dalleVM.messages.count > 0{
                            ForEach(dalleVM.messages.indices, id: \.self){ index in
                                let message = dalleVM.messages[index]
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
                    .onChange(of: dalleVM.messages.count){ _ in
                        withAnimation{
                            reader.scrollTo(bottomID)
                        }
                    }
                }
                Spacer()
                HStack(alignment: .center){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .padding(10)
                        .font(.callout)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                    
                    Button {
                        Task{
                            if !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty{
                                let tempMessage = typingMessage
                                typingMessage = ""
                                await dalleVM.generateImage(prompt: tempMessage)
                            }
                        }
                    } label: {
                        Image(systemName: typingMessage == "" ? "circle" : "paperplane.fill")
                            .foregroundColor(.green)
                            .rotationEffect(.degrees(45))
                            .frame(width: 35, height: 35)
                            .scaleEffect(typingMessage == "" ? 1.2 : 1.5)
                    }

                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("DALL-E")
        }
    }
}

struct DalleView_Previews: PreviewProvider {
    static var previews: some View {
        DalleView()
    }
}
