//
//  MessageView.swift
//  ChattingAPP
//
//  Created by kz on 02/02/2023.
//

import SwiftUI

struct MessageView: View {
    var message: String
    var isUserMessage: Bool
    var isBotMessage: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            if isUserMessage {
                Spacer()
            }
            VStack(alignment: .leading,spacing: 0){
                if isBotMessage{
                    Text("OPENAI BOT")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.leading, 10)
                }
                
                Text(message)
                    .padding(10)
                    .font(.callout)
                    .foregroundColor(isUserMessage ? .white : .black)
                    .background(isUserMessage ? Color.green : Color.gray.opacity(0.25))
                    .cornerRadius(25)
            }
            
            if !isUserMessage {
                Spacer()
            }
            
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}
