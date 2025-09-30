import Testing
import SwiftUI
@testable import SwiftGPT

@Suite("Message Tests")
struct MessageTests {

    @Test("Message has unique ID")
    func messageUniqueID() {
        let message1 = Message(content: .text("Hello"), isUserMessage: true)
        let message2 = Message(content: .text("Hello"), isUserMessage: true)

        #expect(message1.id != message2.id)
    }

    @Test("Text message content")
    func textMessageContent() {
        let message = Message(content: .text("Test"), isUserMessage: false)

        if case let .text(content) = message.content {
            #expect(content == "Test")
        } else {
            Issue.record("Expected text content")
        }
    }

    @Test("Error message content")
    func errorMessageContent() {
        let message = Message(content: .error("Error"), isUserMessage: false)

        if case let .error(content) = message.content {
            #expect(content == "Error")
        } else {
            Issue.record("Expected error content")
        }
    }

    @Test("Indicator message content")
    func indicatorMessageContent() {
        let message = Message(content: .indicator, isUserMessage: false)

        #expect(message.content == .indicator)
    }

    @Test("Image message content")
    func imageMessageContent() {
        let imageData = Data([0x00, 0x01, 0x02])
        let message = Message(content: .image(imageData), isUserMessage: false)

        if case let .image(data) = message.content {
            #expect(data == imageData)
        } else {
            Issue.record("Expected image content")
        }
    }
}
