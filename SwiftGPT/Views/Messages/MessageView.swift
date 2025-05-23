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

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: message.isUserMessage ? .center : .top) {
                    Image(message.isUserMessage ? .personIcon : .gptLogo)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)

                    switch message.content {
                    case let .text(output):
                        Text(output.trimmingCharacters(in: .whitespacesAndNewlines))
                        Text(output)
                            .foregroundStyle(.white)
                            .textSelection(.enabled)
                    case let .error(output):
                        Text(output.trimmingCharacters(in: .whitespacesAndNewlines))
                        Text(output)
                            .foregroundStyle(.red)
                            .textSelection(.enabled)
                    case let .image(imageData):
                        if let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(13)
                                .shadow(color: .green, radius: 1)
                            VStack {
                                Button(action: {
                                    let avc = UIActivityViewController(activityItems: [uiImage], applicationActivities: nil)

                                    avc.completionWithItemsHandler = { (activityType, completed, _, _) in
                                        if completed && activityType == .saveToCameraRoll {
                                            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                                        }
                                    }
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                                       let rootViewController = window.rootViewController {
                                        rootViewController.present(avc, animated: true, completion: nil)
                                    }
                                }) {
                                    Image(systemSymbol: .squareAndArrowUp)
                                        .foregroundStyle(.white)
                                }
                                .padding()

                                Button(action: {
                                    Task {
                                        try await saveImageToLibrary(uiImage)
                                    }
                                }) {
                                    Image(systemSymbol: .squareAndArrowDown)
                                        .foregroundStyle(.white)
                                }
                                .padding()
                            }
                        }
                    case .indicator:
                        MessageIndicatorView()
                    }
                }
                .padding([.top, .bottom])
                .padding(.leading, 10)
            }
            Spacer()
        }
        .background(message.isUserMessage ? Color(.userMessageBackground) : Color(.responseMessageBackground))
        .shadow( radius: message.isUserMessage ? 0 : 0.5)

    }

    func saveImageToLibrary(_ image: UIImage) async throws {
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
}
