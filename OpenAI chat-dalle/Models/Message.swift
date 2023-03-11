//
//  Message.swift
//  OpenAI chat-dalle
//
//  Created by kz on 17/02/2023.
//

import Foundation
import UIKit
import SwiftUI

enum MessageType {
    case text
    case image
    case indicator
}

struct Message {
    var content: Any
    let type: MessageType
    let isUserMessage: Bool
}
