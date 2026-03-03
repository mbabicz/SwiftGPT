# SwiftAI — Claude & DALL·E iOS App

[![mbabicz](https://img.shields.io/static/v1?label=mbabicz&message=SwiftAI&color=blueviolet&logo=github)](https://github.com/mbabicz/SwiftGPT)
[![iOS](https://img.shields.io/badge/iOS%20-16+-blue)](https://github.com/mbabicz/SwiftGPT)
[![Swift](https://img.shields.io/static/v1?style=flat&message=Swift&color=F05138&logo=Swift&logoColor=FFFFFF&label=)](https://github.com/mbabicz/SwiftGPT)
[![Swift](https://img.shields.io/static/v1?style=flat&message=SwiftUI&color=blue&logo=Swift&logoColor=FFFFFF&label=)](https://github.com/mbabicz/SwiftGPT)
[![Powered by Claude](https://img.shields.io/badge/Powered%20by-Claude-blueviolet)](https://www.anthropic.com)

## ABOUT THE PROJECT

SwiftAI is a native iOS application built with SwiftUI that integrates:

- **Anthropic Claude** — conversational AI chat with real-time streaming responses, powered by the Claude REST API directly (no third-party wrapper)
- **OpenAI DALL·E 2** — AI image generation from text prompts

The Claude chat uses the `claude-sonnet-4-6` model with Server-Sent Events (SSE) streaming for a smooth, real-time experience. Users provide their own API keys directly in the app — no hardcoded secrets.

## INSTALLATION

1. Clone the repository
2. Open `SwiftGPT.xcodeproj` in Xcode
3. Build and run on a simulator or device (iOS 16+)
4. In the app, tap the **⚙ Settings** icon and enter:
   - Your **Claude API key** from [console.anthropic.com](https://console.anthropic.com)
   - Your **OpenAI API key** from [platform.openai.com](https://platform.openai.com) *(for DALL·E only)*

## CLAUDE CHAT

Real-time streaming chat powered by Anthropic's Claude API:

- Direct REST integration with `https://api.anthropic.com/v1/messages`
- Streaming via `URLSession` async bytes + Server-Sent Events
- Conversation history maintained per session
- Model: `claude-sonnet-4-6`

## DALL·E 2 IMAGE GENERATION

Generate images from text prompts using OpenAI's DALL·E 2:

- Context menu to share or save generated images to Photos
- Requires a separate OpenAI API key (entered in Settings)

## BUILT WITH

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=for-the-badge&logo=swift&logoColor=white)

- [Anthropic Claude API](https://docs.anthropic.com/en/api) — LLM chat backend
- [OpenAIKit](https://github.com/MarcoDotIO/OpenAIKit) — DALL·E image generation
- [SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols) — type-safe SF Symbols

---

*Powered by [Claude](https://www.anthropic.com/claude) from Anthropic*
