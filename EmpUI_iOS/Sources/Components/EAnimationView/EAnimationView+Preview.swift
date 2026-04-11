import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EAnimationView — Placeholder") {
    let view = EAnimationView()
    let _ = view.configure(with: .init(
        animationName: "loading",
        size: CGSize(width: 120, height: 120)
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EAnimationView — With Styling") {
    let view = EAnimationView()
    let _ = view.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: UIColor.Semantic.borderDefault),
            corners: .init(radius: 12),
            backgroundColor: UIColor.Semantic.backgroundSecondary,
            layoutMargins: UIEdgeInsets(top: .xs, left: .xs, bottom: .xs, right: .xs)
        ),
        animationName: "success",
        loopMode: .loop,
        contentMode: .fit,
        size: CGSize(width: 80, height: 80)
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EAnimationView — Large Fill") {
    let view = EAnimationView()
    let _ = view.configure(with: .init(
        animationName: "celebration",
        loopMode: .autoReverse,
        contentMode: .fill,
        size: CGSize(width: 200, height: 200)
    ))
    view
}
