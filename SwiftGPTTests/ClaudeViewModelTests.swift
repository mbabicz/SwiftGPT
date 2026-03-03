import Testing
@testable import SwiftGPT

@Suite("Claude ViewModel Tests")
struct ClaudeViewModelTests {

    @Test("Initial state is empty")
    func initialState() {
        let viewModel = ClaudeViewModel()

        #expect(viewModel.messages.isEmpty)
        #expect(viewModel.typingMessage.isEmpty)
        #expect(viewModel.isLoading == false)
    }

    @Test("Empty message not sent")
    func emptyMessageNotSent() {
        let viewModel = ClaudeViewModel()
        viewModel.typingMessage = ""

        viewModel.sendMessage()

        #expect(viewModel.messages.isEmpty)
    }

    @Test("Whitespace message not sent")
    func whitespaceMessageNotSent() {
        let viewModel = ClaudeViewModel()
        viewModel.typingMessage = "   "

        viewModel.sendMessage()

        #expect(viewModel.messages.isEmpty)
    }
}
