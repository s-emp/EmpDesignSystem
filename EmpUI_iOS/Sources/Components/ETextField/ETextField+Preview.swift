import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("ETextField -- Default") {
    let view = ETextField()
    let _ = view.configure(with: .init(
        placeholder: "Enter text..."
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextField -- With Text") {
    let view = ETextField()
    let _ = view.configure(with: .init(
        text: "Hello, World!",
        placeholder: "Enter text..."
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextField -- Disabled") {
    let view = ETextField()
    let _ = view.configure(with: .init(
        text: "Disabled field",
        placeholder: "Enter text...",
        isEnabled: false
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextField -- Secure") {
    let view = ETextField()
    let _ = view.configure(with: .init(
        text: "password123",
        placeholder: "Enter password...",
        isSecure: true
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextField -- Email Keyboard") {
    let view = ETextField()
    let _ = view.configure(with: .init(
        placeholder: "Enter email...",
        keyboardType: .email
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextField -- With Margins") {
    let view = ETextField()
    let _ = view.configure(with: .init(
        common: CommonViewModel(layoutMargins: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)),
        placeholder: "Padded field"
    ))
    view
}
