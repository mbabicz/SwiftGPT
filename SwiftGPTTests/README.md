# SwiftGPT Tests

## Overview
Modern XCTest suite for SwiftGPT application using iOS 16.2+ features.

## Structure

### Model Tests
- `MessageTests.swift` - Tests for Message model and MessageContent enum

### ViewModel Tests
- `GPTViewModelTests.swift` - Tests for ChatGPT view model
- `DalleViewModelTests.swift` - Tests for DALL-E view model

## Setup in Xcode

### 1. Add Test Target
```
File → New → Target → Unit Testing Bundle
- Product Name: SwiftGPTTests
- Team: Your Team
- Organization Identifier: com.yourcompany
```

### 2. Configure Test Target
In **Build Settings**:
- Set `iOS Deployment Target` to `16.2`
- Enable `ENABLE_TESTING_SEARCH_PATHS = YES`

In **Build Phases → Link Binary With Libraries**, add:
- SwiftGPT.app (under Target Dependencies)
- XCTest.framework (automatically added)

### 3. Project Uses File System Synchronized Groups
The project uses modern Xcode 15+ feature. Tests are auto-discovered in `SwiftGPTTests/` folder.

## Running Tests

### In Xcode
- **All tests:** `Cmd + U`
- **Single test:** Click ◇ next to test function
- **Test class:** Click ◇ next to class name

### Command Line
```bash
# All tests
xcodebuild test -project SwiftGPT.xcodeproj -scheme SwiftGPT \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Specific test
xcodebuild test -project SwiftGPT.xcodeproj -scheme SwiftGPT \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -only-testing:SwiftGPTTests/MessageTests
```

## Test Structure

### Modern XCTest Pattern
```swift
final class MyTests: XCTestCase {
    func testSomething() throws {
        // Given
        let sut = MyClass()

        // When
        let result = try sut.doSomething()

        // Then
        XCTAssertEqual(result, expectedValue, "Clear failure message")
    }
}
```

### Key Features Used
- ✅ `throws` on test functions for clean error handling
- ✅ Descriptive assertion messages
- ✅ `guard case let` for enum pattern matching
- ✅ No force unwraps (`!`) - proper optionals handling

## Future Enhancements

### 1. Mock APIs
Create protocol-based mocks:
```swift
protocol ChatGPTAPIProtocol {
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String, Error>
}

class MockChatGPTAPI: ChatGPTAPIProtocol {
    var mockResponse: [String] = []
    var shouldThrow = false
    // ...
}
```

### 2. Test Coverage Goals
- [ ] Async/await testing
- [ ] Error handling paths
- [ ] Loading state transitions
- [ ] Message limit enforcement
- [ ] Image generation scenarios

### 3. Swift Testing (iOS 18+)
When updating to iOS 18, consider migrating to Swift Testing:
```swift
import Testing
@testable import SwiftGPT

@Suite("Message Tests")
struct MessageTests {
    @Test("Create message with text")
    func messageCreation() {
        let message = Message(content: .text("Hello"), isUserMessage: true)
        #expect(message.isUserMessage == true)
    }
}
```

## Best Practices

✅ **DO:**
- Use dependency injection in ViewModels
- Test public interfaces, not private implementation
- Write descriptive test names: `testSendMessage_whenEmpty_doesNothing`
- Add assertion messages for clarity
- Keep tests fast (< 0.1s per test)

❌ **DON'T:**
- Test private methods directly
- Use real network calls in tests
- Share state between tests
- Use force unwraps
- Test UI directly (use UI tests for that)

## Debugging Tests

### Enable test output
```swift
print("Debug: \(value)")  // Shows in test logs
```

### Breakpoints
- Add breakpoints in test code
- Run test with `Cmd + U`
- Debugger stops at breakpoints

### Test Failure Tracking
Failed tests show:
- File and line number
- Assertion message
- Expected vs actual values