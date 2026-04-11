import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EDivider -- Горизонтальный") {
    let view = EDivider()
    let _ = view.configure(with: .init())
    view
}

@available(macOS 14.0, *)
#Preview("EDivider -- Вертикальный") {
    let view = EDivider()
    let _ = view.configure(with: .init(axis: .vertical))
    view
}

@available(macOS 14.0, *)
#Preview("EDivider -- Толстый") {
    let view = EDivider()
    let _ = view.configure(with: .init(thickness: 4))
    view
}

@available(macOS 14.0, *)
#Preview("EDivider -- Кастомный цвет") {
    let view = EDivider()
    let _ = view.configure(with: .init(
        thickness: 2,
        color: NSColor.Semantic.actionPrimary
    ))
    view
}
