import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("ETextView — Default") {
    let view = ETextView()
    let _ = view.configure(with: .init(
        placeholder: "Enter text..."
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextView — With Text") {
    let view = ETextView()
    let _ = view.configure(with: .init(
        text: "This is a multiline text view with some content that spans multiple lines.",
        placeholder: "Enter text..."
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextView — Read Only") {
    let view = ETextView()
    let _ = view.configure(with: .init(
        common: CommonViewModel(
            backgroundColor: UIColor.Semantic.backgroundSecondary,
            layoutMargins: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        ),
        text: "This text view is read-only. The user cannot edit this content.",
        isEditable: false
    ))
    view
}

@available(iOS 17.0, *)
#Preview("ETextView — Custom Font") {
    let view = ETextView()
    let _ = view.configure(with: .init(
        common: CommonViewModel(
            border: CommonViewModel.Border(width: 1, color: UIColor.Semantic.textTertiary),
            corners: CommonViewModel.Corners(radius: 8),
            layoutMargins: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        ),
        text: "Custom styled text view",
        placeholder: "Type here...",
        font: .systemFont(ofSize: 18, weight: .medium),
        textColor: UIColor.Semantic.textAccent
    ))
    view
}
