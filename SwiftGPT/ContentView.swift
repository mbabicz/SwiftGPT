//
//  ContentView.swift
//  SwiftGPT
//
//  Created by mbabicz on 07/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            ChatGPTView().tabItem {
                Label(L10n.Chatgpt.Tab.title, systemSymbol: .ellipsisBubble)
            }
            DalleView().tabItem {
                Label(L10n.Dalle.Tab.title, systemSymbol: .paintbrush)
            }
        }
    }
}

#Preview {
    ContentView()
}
