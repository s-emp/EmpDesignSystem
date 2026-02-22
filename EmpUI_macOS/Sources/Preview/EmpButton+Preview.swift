import AppKit
import SwiftUI

// MARK: - Styles

@available(macOS 14.0, *)
#Preview("Filled — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Filled Primary"))))
    button
}

@available(macOS 14.0, *)
#Preview("Base — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.base(.primary, content: .init(center: .text("Base Primary"))))
    button
}

@available(macOS 14.0, *)
#Preview("Outlined — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.outlined(.primary, content: .init(center: .text("Outlined Primary"))))
    button
}

@available(macOS 14.0, *)
#Preview("Ghost — Primary") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.ghost(.primary, content: .init(center: .text("Ghost Primary"))))
    button
}

// MARK: - Danger

@available(macOS 14.0, *)
#Preview("Filled — Danger") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.danger, content: .init(center: .text("Delete"))))
    button
}

@available(macOS 14.0, *)
#Preview("Base — Danger") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.base(.danger, content: .init(center: .text("Delete"))))
    button
}

@available(macOS 14.0, *)
#Preview("Outlined — Danger") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.outlined(.danger, content: .init(center: .text("Delete"))))
    button
}

// MARK: - Sizes

@available(macOS 14.0, *)
#Preview("Size — Small") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Small")), size: .small))
    button
}

@available(macOS 14.0, *)
#Preview("Size — Medium") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Medium"))))
    button
}

@available(macOS 14.0, *)
#Preview("Size — Large") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Large")), size: .large))
    button
}

// MARK: - Content Variants

@available(macOS 14.0, *)
#Preview("Icon + Text") {
    let button = EmpButton()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "lock.fill", accessibilityDescription: nil)!
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(
        leading: .icon(icon),
        center: .text("Sign In")
    )))
    button
}

@available(macOS 14.0, *)
#Preview("Text + Icon") {
    let button = EmpButton()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "arrow.right", accessibilityDescription: nil)!
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(
        center: .text("Next"),
        trailing: .icon(icon)
    )))
    button
}

@available(macOS 14.0, *)
#Preview("Icon Only") {
    let button = EmpButton()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "plus", accessibilityDescription: nil)!
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(
        center: .icon(icon)
    )))
    button
}

@available(macOS 14.0, *)
#Preview("Title + Subtitle") {
    let button = EmpButton()
    // swiftlint:disable:next force_unwrapping
    let icon = NSImage(systemSymbolName: "person.fill", accessibilityDescription: nil)!
    let _ = button.configure(with: EmpButton.Preset.filled(
        .primary,
        content: .init(
            leading: .icon(icon),
            center: .titleSubtitle(title: "Profile", subtitle: "Settings")
        ),
        size: .large
    ))
    button
}

// MARK: - Disabled

@available(macOS 14.0, *)
#Preview("Disabled") {
    let button = EmpButton()
    let _ = button.configure(with: EmpButton.Preset.filled(.primary, content: .init(center: .text("Disabled"))))
    button.isEnabled = false
    return button
}
