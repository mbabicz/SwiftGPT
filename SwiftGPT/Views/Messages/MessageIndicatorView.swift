//
//  MessageIndicatorView.swift
//  SwiftGPT
//
//  Created by mbabicz on 06/02/2023.
//

import SwiftUI

struct MessageIndicatorView: View {
    var body: some View {
        HStack {
            DotView()
            DotView(delay: 0.2)
            DotView(delay: 0.4)
        }
        .padding(12)
        .background(Color.gray.opacity(0.25))
        .cornerRadius(25)
    }
}

struct DotView: View {
    @State var scale: CGFloat = 0.5
    @State var delay: Double = 0

    var body: some View {
        Circle()
            .frame(width: 7, height: 7)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(Animation.easeInOut.repeatForever().delay(delay)) {
                    self.scale = 1
                }
            }
    }
}

struct MessageIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        MessageIndicatorView()
    }
}
