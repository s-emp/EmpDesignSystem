import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpImage — SF Symbol") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "star.fill", accessibilityDescription: nil)!
    let _ = view.configure(with: .init(
        image: icon,
        tintColor: NSColor.Semantic.actionPrimary,
        size: CGSize(width: 24, height: 24)
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EmpImage — SF Symbol Large") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "heart.fill", accessibilityDescription: nil)!
    let _ = view.configure(with: .init(
        image: icon,
        tintColor: NSColor.Semantic.actionDanger,
        size: CGSize(width: 48, height: 48)
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EmpImage — SF Symbol No Tint") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "globe", accessibilityDescription: nil)!
    let _ = view.configure(with: .init(
        image: icon,
        size: CGSize(width: 32, height: 32)
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EmpImage — With Common Styling") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "person.fill", accessibilityDescription: nil)!
    let _ = view.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: NSColor.Semantic.borderDefault),
            corners: .init(radius: 8),
            backgroundColor: NSColor.Semantic.backgroundSecondary,
            layoutMargins: NSEdgeInsets(top: .xs, left: .xs, bottom: .xs, right: .xs)
        ),
        image: icon,
        tintColor: NSColor.Semantic.textPrimary,
        size: CGSize(width: 32, height: 32)
    ))
    view
}

@available(macOS 14.0, *)
#Preview("EmpImage — Center Mode") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil)!
    let _ = view.configure(with: .init(
        image: icon,
        tintColor: NSColor.Semantic.actionSuccess,
        size: CGSize(width: 40, height: 40),
        contentMode: .center
    ))
    view
}
