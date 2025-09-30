import Testing
@testable import SwiftGPT

@Suite("GPT ViewModel Tests")
struct GPTViewModelTests {

    @Test("Initial state is empty")
    func initialState() {
        let viewModel = GPTViewModel()

        #expect(viewModel.messages.isEmpty)
        #expect(viewModel.typingMessage.isEmpty)
        #expect(viewModel.isLoading == false)
    }

    @Test("Empty message not sent")
    func emptyMessageNotSent() {
        let viewModel = GPTViewModel()
        viewModel.typingMessage = ""

        viewModel.sendMessage()

        #expect(viewModel.messages.isEmpty)
    }

    @Test("Whitespace message not sent")
    func whitespaceMessageNotSent() {
        let viewModel = GPTViewModel()
        viewModel.typingMessage = "   "

        viewModel.sendMessage()

        #expect(viewModel.messages.isEmpty)
    }
}
