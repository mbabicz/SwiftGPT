//
//  DalleView.swift
//  OpenAI GPT-DALL-E
//
//  Created by kz on 06/02/2023.
//

import SwiftUI

struct DalleView: View {
    @State var typingMessage: String = ""
    @ObservedObject var DalleVM = DalleViewModel()
    @State var models: [Any] = []
    @Namespace var bottomID

    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                ScrollViewReader { reader in
                    ScrollView(.vertical) {
                        ForEach(0 ..< models.count, id: \.self) { index in
                            let model = models[index]
                            HStack {
                                if let text = model as? String {
                                    MessageView(message: text.replacingOccurrences(of: "Me: ", with: ""), isUserMessage: true, isBotMessage: false)
                                } else if let image = model as? UIImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(13)
                                        .shadow(color: .green , radius: 4)
                                        .padding()
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
                Spacer()
                HStack(alignment: .center){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .padding(12)
                        .font(.callout)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                        
                    Button {
                        if !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty{
                            models.append(typingMessage)
                            Task{
                                models.append(await DalleVM.generateImage(prompt: typingMessage)!)
                                typingMessage = ""
                            }
                        }
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
            .navigationBarTitle("DALL-E")
        }
    }
}

struct DalleView_Previews: PreviewProvider {
    static var previews: some View {
        DalleView()
    }
}
