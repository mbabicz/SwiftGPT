//
//  MessageView.swift
//  ChattingAPP
//
//  Created by kz on 02/02/2023.
//

import SwiftUI

struct MessageView: View {
    var message: Message    
    
    var body: some View {
        HStack(spacing: 0) {
            if message.isUserMessage {
                Spacer()
            }
            VStack(alignment: .leading, spacing: 0) {
                if !message.isUserMessage {
                    Text("OPENAI BOT")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.trailing, 10)
                }
                
                switch message.type {
                case .text:
                    let output = (message.content as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                    Text(output)
                        .padding(10)
                        .font(.callout)
                        .foregroundColor(message.isUserMessage ? .white : .black)
                        .background(message.isUserMessage ? Color.green : Color.gray.opacity(0.25))
                        .cornerRadius(25)
                case .image:
                    Image(uiImage: message.content as! UIImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(13)
                        .shadow(color: .green, radius: 4)
                        .padding()
                case .indicator:
                    MessageIndicatorView()
                }
                Spacer()
            }
            if !message.isUserMessage {
                Spacer()
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

