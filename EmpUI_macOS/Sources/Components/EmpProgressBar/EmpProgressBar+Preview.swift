import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpProgressBar — 0%") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(progress: 0))
    view
}

@available(macOS 14.0, *)
#Preview("EmpProgressBar — 25%") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(progress: 0.25))
    view
}

@available(macOS 14.0, *)
#Preview("EmpProgressBar — 50%") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(progress: 0.5))
    view
}

@available(macOS 14.0, *)
#Preview("EmpProgressBar — 75%") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(progress: 0.75))
    view
}

@available(macOS 14.0, *)
#Preview("EmpProgressBar — 100%") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(progress: 1.0))
    view
}

@available(macOS 14.0, *)
#Preview("EmpProgressBar — Толстая полоса") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(
        progress: 0.6,
        barHeight: 12
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EmpProgressBar — Кастомные цвета") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(
        progress: 0.4,
        fillColor: NSColor.Semantic.actionSuccess,
        barHeight: 8
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EmpProgressBar — Danger") {
    let view = EmpProgressBar()
    let _ = view.configure(with: .init(
        progress: 0.9,
        fillColor: NSColor.Semantic.actionDanger,
        barHeight: 6
    ))
    view
}
