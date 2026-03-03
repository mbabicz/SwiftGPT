//
//  ClaudeViewModel.swift
//  SwiftGPT
//
//  Chat ViewModel powered by Anthropic Claude REST API with streaming.
//

import Foundation

final class ClaudeViewModel: ObservableObject {

    @Published var messages: [Message] = []
    @Published var typingMessage: String = ""
    @Published var isLoading: Bool = false
    let bottomID = UUID()

    private var conversationHistory: [[String: String]] = []

    func sendMessage() {
        guard !typingMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let tempMessage = typingMessage
        typingMessage = ""
        Task {
            await getResponse(text: tempMessage)
        }
    }

    @MainActor
    private func addMessage(_ content: MessageContent, isUserMessage: Bool) {
        guard let lastMessage = self.messages.last else {
            self.messages.append(Message(content: content, isUserMessage: isUserMessage))
            return
        }
        let message = Message(content: content, isUserMessage: isUserMessage)
        if case .indicator = lastMessage.content, !lastMessage.isUserMessage {
            self.messages[self.messages.count - 1] = message
        } else {
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

        conversationHistory.append(["role": "user", "content": text])

        let apiKey = APIKeyManager.shared.claudeApiKey
        guard !apiKey.isEmpty else {
            await addMessage(.error("Claude API key not set. Please add your key in Settings."), isUserMessage: false)
            await MainActor.run { isLoading = false }
            conversationHistory.removeLast()
            return
        }

        do {
            var fullResponse = ""
            let stream = try await streamResponse(messages: conversationHistory, apiKey: apiKey)
            for try await chunk in stream {
                fullResponse += chunk
                let captured = fullResponse
                await MainActor.run {
                    guard let lastIndex = self.messages.indices.last else { return }
                    self.messages[lastIndex].content = .text(captured)
                }
            }
            conversationHistory.append(["role": "assistant", "content": fullResponse])
        } catch {
            await addMessage(.error(error.localizedDescription), isUserMessage: false)
            conversationHistory.removeLast()
        }

        await MainActor.run { isLoading = false }
    }

    private func streamResponse(
        messages: [[String: String]],
        apiKey: String
    ) async throws -> AsyncThrowingStream<String, Error> {
        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        let body: [String: Any] = [
            "model": Config.API.claudeModel,
            "max_tokens": Config.API.maxTokens,
            "stream": true,
            "messages": messages
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (bytes, response) = try await URLSession.shared.bytes(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ClaudeAPIError.invalidResponse
        }

        return AsyncThrowingStream { continuation in
            Task {
                do {
                    for try await line in bytes.lines {
                        guard line.hasPrefix("data: ") else { continue }
                        let jsonStr = String(line.dropFirst(6))
                        guard jsonStr != "[DONE]",
                              let data = jsonStr.data(using: .utf8),
                              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                        else { continue }

                        if let type = json["type"] as? String,
                           type == "content_block_delta",
                           let delta = json["delta"] as? [String: Any],
                           delta["type"] as? String == "text_delta",
                           let text = delta["text"] as? String {
                            continuation.yield(text)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

enum ClaudeAPIError: LocalizedError {
    case invalidResponse

    var errorDescription: String? {
        "Invalid response from Claude API. Please verify your API key."
    }
}
