import Testing
@testable import SwiftGPT

@Suite("DALL-E ViewModel Tests")
struct DalleViewModelTests {

    @Test("Initial state is empty")
    func initialState() {
        let viewModel = DalleViewModel()

        #expect(viewModel.messages.isEmpty)
        #expect(viewModel.typingMessage.isEmpty)
        #expect(viewModel.isLoading == false)
    }

    @Test("Empty message not sent")
    func emptyMessageNotSent() {
        let viewModel = DalleViewModel()
        viewModel.typingMessage = ""

        viewModel.sendMessage()

        #expect(viewModel.messages.isEmpty)
    }

    @Test("Whitespace message not sent")
    func whitespaceMessageNotSent() {
        let viewModel = DalleViewModel()
        viewModel.typingMessage = "   "

        viewModel.sendMessage()

        #expect(viewModel.messages.isEmpty)
    }
}
