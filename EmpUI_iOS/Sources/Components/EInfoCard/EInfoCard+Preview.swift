import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("EInfoCard — Default") {
    let card = EInfoCard()
    let _ = card.configure(with: EInfoCard.Preset.default(subtitle: "Total Time", value: "12h 15m"))
    card
}

@available(iOS 17.0, *)
#Preview("EInfoCard — Custom Colors") {
    let card = EInfoCard()
    let _ = card.configure(with: .init(
        common: CommonViewModel(
            corners: .init(radius: 12),
            layoutMargins: UIEdgeInsets(
                top: .m,
                left: .m,
                bottom: .m,
                right: .m
            )
        ),
        subtitle: "Active Time",
        value: "8h 34m",
        background: .color(UIColor.Semantic.cardLavender)
    ))
    card
}

@available(iOS 17.0, *)
#Preview("EInfoCard — Gradient") {
    let card = EInfoCard()
    let _ = card.configure(with: EInfoCard.Preset.gradient(
        subtitle: "Longest Session",
        value: "1h 47m",
        gradient: .Preset.lavenderToSky
    ))
    card
}

@available(iOS 17.0, *)
#Preview("EInfoCard — Large Value") {
    let card = EInfoCard()
    let _ = card.configure(with: EInfoCard.Preset.default(subtitle: "Apps Used", value: "10"))
    card
}
