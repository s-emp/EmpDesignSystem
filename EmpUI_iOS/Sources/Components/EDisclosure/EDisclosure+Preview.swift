import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EDisclosure — Collapsed") {
    let view = EDisclosure()
    let _ = view.configure(with: .init(title: "Section Title"))
    let content = UILabel()
    let _ = { content.text = "Content inside disclosure" }()
    let _ = { content.numberOfLines = 0 }()
    let _ = view.setContent(content)
    view
}

@available(iOS 17.0, *)
#Preview("EDisclosure — Expanded") {
    let view = EDisclosure()
    let _ = view.configure(with: .init(
        title: "Expanded Section",
        isExpanded: true
    ))
    let content = UILabel()
    let _ = { content.text = "This content is visible when the disclosure is expanded." }()
    let _ = { content.numberOfLines = 0 }()
    let _ = view.setContent(content)
    view
}

@available(iOS 17.0, *)
#Preview("EDisclosure — With Margins") {
    let view = EDisclosure()
    let _ = view.configure(with: .init(
        common: CommonViewModel(layoutMargins: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)),
        title: "Section With Margins",
        isExpanded: true
    ))
    let content = UILabel()
    let _ = { content.text = "Content with margins applied." }()
    let _ = { content.numberOfLines = 0 }()
    let _ = view.setContent(content)
    view
}
