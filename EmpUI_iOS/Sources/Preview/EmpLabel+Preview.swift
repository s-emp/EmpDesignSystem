import UIKit
import SwiftUI

@available(iOS 17.0, *)
#Preview("EmpLabel — Title") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Title Text", style: .title))
    label
}

@available(iOS 17.0, *)
#Preview("EmpLabel — Body") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Body text goes here. This is a longer piece of text.", style: .body))
    label
}

@available(iOS 17.0, *)
#Preview("EmpLabel — Caption") {
    let label = EmpLabel()
    label.configure(with: .init(text: "Caption text", style: .caption))
    label
}
