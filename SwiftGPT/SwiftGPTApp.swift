//
//  SwiftGPTApp.swift
//  SwiftGPT
//
//  Created by mbabicz on 07/02/2023.
//

import SwiftUI

@main
struct SwiftGPTApp: App {
    let dalleViewModel = DalleViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dalleViewModel)

        }
    }
}
