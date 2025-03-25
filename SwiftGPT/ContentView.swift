//
//  ContentView.swift
//  SwiftGPT
//
//  Created by mbabicz on 07/02/2023.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            TabView {
                ChatGPTView().tabItem {
                    Label("CHAT BOT", systemSymbol: .ellipsisBubble)
                }
                DalleView().tabItem {
                    Label("DALL-E 2", systemSymbol: .paintbrush)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
