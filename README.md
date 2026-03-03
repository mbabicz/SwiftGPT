# SwiftAI — Claude & DALL·E iOS App

[![mbabicz](https://img.shields.io/static/v1?label=mbabicz&message=SwiftAI&color=blueviolet&logo=github)](https://github.com/mbabicz/SwiftGPT)
[![iOS](https://img.shields.io/badge/iOS%20-16+-blue)](https://github.com/mbabicz/SwiftGPT)
[![Swift](https://img.shields.io/static/v1?style=flat&message=Swift&color=F05138&logo=Swift&logoColor=FFFFFF&label=)](https://github.com/mbabicz/SwiftGPT)
[![Swift](https://img.shields.io/static/v1?style=flat&message=SwiftUI&color=blue&logo=Swift&logoColor=FFFFFF&label=)](https://github.com/mbabicz/SwiftGPT)
[![Powered by Claude](https://img.shields.io/badge/Powered%20by-Claude-blueviolet)](https://www.anthropic.com)
[![Powered by DALL·E](https://img.shields.io/badge/Powered%20by-DALL%C2%B7E-412991)](https://openai.com/dall-e-2)

## ABOUT THE PROJECT

SwiftAI is a native iOS application built with SwiftUI that integrates:

- **Anthropic Claude** — conversational AI chat with real-time streaming responses, powered by the Claude REST API directly (no third-party wrapper)
- **OpenAI DALL·E 2** — AI image generation from text prompts

The Claude chat uses the `claude-sonnet-4-6` model with Server-Sent Events (SSE) streaming for a smooth, real-time experience. Users provide their own API keys directly in the app — no hardcoded secrets.

|<img src = "https://user-images.githubusercontent.com/49866616/229373384-c84099f2-0b7b-4b83-b25e-5e6689529951.gif" width="300" height="600" />|<img src = "https://user-images.githubusercontent.com/49866616/221298939-329f463f-0383-41ad-aea2-c3a4c536b181.gif" width="300" height="600" />|
|:-:|:-:|

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

|<img src = "https://user-images.githubusercontent.com/49866616/220471468-b9a92f20-027d-4258-87fc-c300425d3d17.png"  width="286" height="558" />|<img src = "https://user-images.githubusercontent.com/49866616/220471564-14265138-4158-4d69-a817-4743ac62279a.png"  width="286" height="558" />|
|:-:|:-:|

## DALL·E 2 IMAGE GENERATION

Generate images from text prompts using OpenAI's DALL·E 2:

- Context menu to share or save generated images to Photos
- Requires a separate OpenAI API key (entered in Settings)

|<img src = "https://user-images.githubusercontent.com/49866616/220471779-1c752dc6-2d30-4c5f-a9b5-8f06f3fb3379.png"  width="286" height="558" />|<img src = "https://user-images.githubusercontent.com/49866616/220471898-a4b5652b-3d17-4de2-a0c9-071d556c8d02.png"  width="286" height="558" />|
|:-:|:-:|

## BUILT WITH

![Swift](https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=for-the-badge&logo=swift&logoColor=white)

- [Anthropic Claude API](https://docs.anthropic.com/en/api) — LLM chat backend
- [OpenAIKit](https://github.com/MarcoDotIO/OpenAIKit) — DALL·E image generation
- [SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols) — type-safe SF Symbols
