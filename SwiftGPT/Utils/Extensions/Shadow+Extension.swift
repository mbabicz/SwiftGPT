//
//  Shadow+Extension.swift
//  SwiftGPT
//
//  Design System - Shadows
//

import SwiftUI

extension View {
    // MARK: - Shadow Modifiers
    func appShadowSM() -> some View {
        shadow(color: .black.opacity(0.1), radius: 0.5, x: 0, y: 1)
    }

    func appShadowMD() -> some View {
        shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 2)
    }

    func appShadowLG() -> some View {
        shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }

    func appShadowColored(_ color: Color, radius: CGFloat = 1) -> some View {
        shadow(color: color, radius: radius)
    }
}
