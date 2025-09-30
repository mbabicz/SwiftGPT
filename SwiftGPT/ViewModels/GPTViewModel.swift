//
//  GPTViewModel.swift
//  SwiftGPT
//
//  Created by mbabicz on 05/03/2023.
//

import Foundation
import ChatGPTSwift

final class GPTViewModel: ObservableObject {

    private let api: ChatGPTAPI
    @Published var messages: [Message] = []
    @Published var typingMessage: String = ""
    @Published var isLoading: Bool = false
    let bottomID = UUID()

    init(api: ChatGPTAPI = ChatGPTAPI(apiKey: Secrets.openaiApiKey)) {
        self.api = api
    }

    func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        let tempMessage = typingMessage
        typingMessage = ""
        Task {
            await getResponse(text: tempMessage)
        }
    }

    @MainActor
    private func addMessage(_ content: MessageContent, isUserMessage: Bool) {
        /// if messages list is empty just add new message
        guard let lastMessage = self.messages.last else {
            let message = Message(content: content, isUserMessage: isUserMessage)
            self.messages.append(message)
            return
        }
        let message = Message(content: content, isUserMessage: isUserMessage)

        /// if last message is an indicator switch with new one
        if case .indicator = lastMessage.content, !lastMessage.isUserMessage {
            self.messages[self.messages.count - 1] = message
        } else {
            /// otherwise, add new message to the end of the list
            self.messages.append(message)
        }

        if self.messages.count > Config.Messages.maxMessages {
            self.messages.removeFirst()
        }
    }

    func getResponse(text: String) async {
        await MainActor.run { isLoading = true }
        await addMessage(.text(text), isUserMessage: true)
        await addMessage(.indicator, isUserMessage: false)

        do {
            let stream = try await api.sendMessageStream(text: text)
            for try await line in stream {
                await MainActor.run {
                    guard let lastIndex = self.messages.indices.last,
                          case .text(let currentText) = self.messages[lastIndex].content else { return }
                    self.messages[lastIndex].content = .text(currentText + line)
                }
            }
        } catch {
            await addMessage(.error(error.localizedDescription), isUserMessage: false)
        }

        await MainActor.run { isLoading = false }
    }
}
