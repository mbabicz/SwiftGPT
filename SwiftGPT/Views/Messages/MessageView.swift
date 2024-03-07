//
//  MessageView.swift
//  SwiftGPT
//
//  Created by mbabicz on 02/02/2023.
//

import SwiftUI

struct MessageView: View {
    var message: Message

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: message.isUserMessage ? .center : .top){
                    Image(message.isUserMessage ? "person-icon" : "gpt-logo")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 10)

                    switch message.type {
                    case .text:
                        let output = (message.content as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                        Text(output)
                            .foregroundColor(.white)
                            .textSelection(.enabled)
                    case .error:
                        let output = (message.content as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                        Text(output)
                            .foregroundColor(.red)
                            .textSelection(.enabled)

                    case .image:
                        HStack(alignment: .center) {
                            Image(uiImage: message.content as! UIImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(13)
                                .shadow(color: .green, radius: 1)
                            VStack{
                                Button(action: {
                                    guard let image = message.content as? UIImage else {
                                        return
                                    }
                                    
                                    let avc = UIActivityViewController(activityItems: [image, UIImage()], applicationActivities: nil)
                                    
                                    avc.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
                                        if completed && activityType == .saveToCameraRoll {
                                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                        }
                                    }
                                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                       let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                                       let rootViewController = window.rootViewController {
                                        rootViewController.present(avc, animated: true, completion: nil)
                                    }
                                }) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                
                                Button(action: {
                                    guard let image = message.content as? UIImage else {
                                        return
                                    }
                                    
                                    let imageSaver = ImageSaver()
                                    imageSaver.writeToPhotoAlbum(image: image)

                                }) {
                                    Image(systemName: "square.and.arrow.down")
                                        .foregroundColor(.white)
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
        .background(message.isUserMessage ? Color(red: 53/255, green: 54/255, blue: 65/255) : Color(red: 68/255, green: 70/255, blue: 83/255))
        .shadow( radius: message.isUserMessage ? 0 : 0.5)

    }
}
