//
//  SettingsView.swift
//  SwiftGPT
//
//  Settings screen for entering Claude and OpenAI API keys.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var keyManager = APIKeyManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var claudeKeyInput = ""
    @State private var openaiKeyInput = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SecureField("sk-ant-api...", text: $claudeKeyInput)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } header: {
                    Text("Claude API Key")
                } footer: {
                    Text("Required for the AI chat. Get your key at console.anthropic.com")
                }

                Section {
                    SecureField("sk-...", text: $openaiKeyInput)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } header: {
                    Text("OpenAI API Key")
                } footer: {
                    Text("Required for DALL·E image generation.")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        keyManager.claudeApiKey = claudeKeyInput.trimmingCharacters(in: .whitespaces)
                        keyManager.openaiApiKey = openaiKeyInput.trimmingCharacters(in: .whitespaces)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                claudeKeyInput = keyManager.claudeApiKey
                openaiKeyInput = keyManager.openaiApiKey
            }
        }
    }
}
