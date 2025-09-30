//
//  MessageView.swift
//  SwiftGPT
//
//  Created by mbabicz on 02/02/2023.
//

import SwiftUI
import PhotosUI

struct MessageView: View {
    var message: Message
    @State private var showErrorAlert = false
    @State private var errorMessage = ""

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: message.isUserMessage ? .center : .top) {
                    Image(message.isUserMessage ? .personIcon : .gptLogo)
                        .resizable()
                        .frame(width: Config.UserInterface.avatarSize, height: Config.UserInterface.avatarSize)
                        .padding(.trailing, .appSpacingSM)
                        .accessibilityLabel(message.isUserMessage ? L10n.Accessibility.Image.user : L10n.Accessibility.Image.gpt)

                    switch message.content {
                    case let .text(output):
                        Text(output)
                            .foregroundStyle(.white)
                            .textSelection(.enabled)
                    case let .error(output):
                        Text(output)
                            .foregroundStyle(.red)
                            .textSelection(.enabled)
                    case let .image(imageData):
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(Config.UserInterface.imageCornerRadius)
                                .shadow(color: .green, radius: 1)
                                .accessibilityLabel(L10n.Accessibility.Image.generated)
                                .contextMenu {
                                    ShareLink(item: Image(uiImage: uiImage), preview: SharePreview("Generated Image"))
                                        .accessibilityLabel(L10n.Accessibility.Button.share)

                                    Button {
                                        Task {
                                            do {
                                                try await saveImageToLibrary(uiImage)
                                            } catch {
                                                await MainActor.run {
                                                    errorMessage = error.localizedDescription
                                                    showErrorAlert = true
                                                }
                                            }
                                        }
                                    } label: {
                                        Label("Save to Photos", systemSymbol: .squareAndArrowDown)
                                    }
                                    .accessibilityLabel(L10n.Accessibility.Button.save)
                                }
                        }
                    case .indicator:
                        MessageIndicatorView()
                    }
                }
                .padding([.top, .bottom], .appSpacingMD)
                .padding(.leading, .appSpacingSM)
            }
            Spacer()
        }
        .background(message.isUserMessage ? Color(.userMessageBackground) : Color(.responseMessageBackground))
        .shadow( radius: message.isUserMessage ? 0 : 0.5)
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    func saveImageToLibrary(_ image: UIImage) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
}
