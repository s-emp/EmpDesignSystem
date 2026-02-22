import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EmpImage — SF Symbol") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = UIImage(systemName: "star.fill")!
    let _ = view.configure(with: .init(
        image: icon,
        tintColor: UIColor.Semantic.actionPrimary,
        size: CGSize(width: 24, height: 24)
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpImage — SF Symbol Large") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = UIImage(systemName: "heart.fill")!
    let _ = view.configure(with: .init(
        image: icon,
        tintColor: UIColor.Semantic.actionDanger,
        size: CGSize(width: 48, height: 48)
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpImage — SF Symbol No Tint") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = UIImage(systemName: "globe")!
    let _ = view.configure(with: .init(
        image: icon,
        size: CGSize(width: 32, height: 32)
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpImage — With Common Styling") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = UIImage(systemName: "person.fill")!
    let _ = view.configure(with: .init(
        common: CommonViewModel(
            border: .init(width: 1, color: UIColor.Semantic.borderDefault),
            corners: .init(radius: 8),
            backgroundColor: UIColor.Semantic.backgroundSecondary,
            layoutMargins: UIEdgeInsets(top: .xs, left: .xs, bottom: .xs, right: .xs)
        ),
        image: icon,
        tintColor: UIColor.Semantic.textPrimary,
        size: CGSize(width: 32, height: 32)
    ))
    view
}

@available(iOS 17.0, *)
#Preview("EmpImage — Center Mode") {
    let view = EmpImage()
    // swiftlint:disable:next force_unwrapping
    let icon = UIImage(systemName: "checkmark.circle.fill")!
    let _ = view.configure(with: .init(
        image: icon,
        tintColor: UIColor.Semantic.actionSuccess,
        size: CGSize(width: 40, height: 40),
        contentMode: .center
    ))
    view
}
