import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EAnimationContainer — Fade") {
    let container = EAnimationContainer()
    let _ = container.configure(with: .init(transition: .fade, duration: 0.5))
    let label = EText()
    let _ = label.configure(with: .init(content: .plain(.init(text: "Fade анимация"))))
    let _ = container.setContent(label)
    container
}

@available(macOS 14.0, *)
#Preview("EAnimationContainer — Scale") {
    let container = EAnimationContainer()
    let _ = container.configure(with: .init(transition: .scale(from: 0.5), duration: 0.3))
    let label = EText()
    let _ = label.configure(with: .init(content: .plain(.init(text: "Scale анимация"))))
    let _ = container.setContent(label)
    container
}

@available(macOS 14.0, *)
#Preview("EAnimationContainer — Slide Leading") {
    let container = EAnimationContainer()
    let _ = container.configure(with: .init(transition: .slide(edge: .leading), duration: 0.4))
    let label = EText()
    let _ = label.configure(with: .init(content: .plain(.init(text: "Slide анимация"))))
    let _ = container.setContent(label)
    container
}
