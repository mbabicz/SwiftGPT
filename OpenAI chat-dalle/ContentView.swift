//
//  ContentView.swift
//  OpenAI chat-dalle
//
//  Created by kz on 07/02/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            TabView{
                ChatBotView().tabItem {
                    Image(systemName: "message.fill")
                }.tag(0)
                
                DalleView().tabItem {
                    Image(systemName: "paintbrush.pointed.fill")
                }.tag(1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
