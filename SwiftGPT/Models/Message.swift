//
//  Message.swift
//  SwiftGPT
//
//  Created by mbabicz on 17/02/2023.
//

import Foundation
import SwiftUI

enum MessageContent: Equatable {
    case text(String)
    case image(Data)
    case indicator
    case error(String)
}

struct Message: Identifiable, Equatable {
    var id = UUID()
    var content: MessageContent
    let isUserMessage: Bool
}
