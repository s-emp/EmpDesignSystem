import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EListContainer — Вертикальный") {
    let container = EListContainer()
    let _ = container.configure(with: .init(
        spacing: 8
    ))
    let _ = container.setItems([
        .text(.init(content: .plain(.init(text: "Элемент 1")))),
        .text(.init(content: .plain(.init(text: "Элемент 2")))),
        .text(.init(content: .plain(.init(text: "Элемент 3")))),
    ])
    container
}

@available(macOS 14.0, *)
#Preview("EListContainer — Горизонтальный") {
    let container = EListContainer()
    let _ = container.configure(with: .init(
        axis: .horizontal,
        spacing: 12
    ))
    let _ = container.setItems([
        .text(.init(content: .plain(.init(text: "A")))),
        .text(.init(content: .plain(.init(text: "B")))),
        .text(.init(content: .plain(.init(text: "C")))),
    ])
    container
}
