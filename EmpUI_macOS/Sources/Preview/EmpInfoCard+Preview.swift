import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpInfoCard — Default") {
    let card = EmpInfoCard()
    let _ = card.configure(with: .init(
        common: CommonViewModel(
            corners: .init(radius: 12),
            layoutMargins: NSEdgeInsets(
                top: EmpSpacing.m.rawValue,
                left: EmpSpacing.m.rawValue,
                bottom: EmpSpacing.m.rawValue,
                right: EmpSpacing.m.rawValue
            )
        ),
        subtitle: "Total Time",
        value: "12h 15m"
    ))
    card
}

@available(macOS 14.0, *)
#Preview("EmpInfoCard — Custom Colors") {
    let card = EmpInfoCard()
    let _ = card.configure(with: .init(
        common: CommonViewModel(
            corners: .init(radius: 12),
            layoutMargins: NSEdgeInsets(
                top: EmpSpacing.m.rawValue,
                left: EmpSpacing.m.rawValue,
                bottom: EmpSpacing.m.rawValue,
                right: EmpSpacing.m.rawValue
            )
        ),
        subtitle: "Active Time",
        value: "8h 34m",
        background: .color(NSColor.Semantic.cardLavender)
    ))
    card
}

@available(macOS 14.0, *)
#Preview("EmpInfoCard — Gradient") {
    let card = EmpInfoCard()
    let _ = card.configure(with: .init(
        common: CommonViewModel(
            corners: .init(radius: 12),
            layoutMargins: NSEdgeInsets(
                top: EmpSpacing.m.rawValue,
                left: EmpSpacing.m.rawValue,
                bottom: EmpSpacing.m.rawValue,
                right: EmpSpacing.m.rawValue
            )
        ),
        subtitle: "Longest Session",
        value: "1h 47m",
        subtitleColor: .white.withAlphaComponent(0.7),
        valueColor: .white,
        background: .gradient(EmpGradient.Preset.lavenderToSky)
    ))
    card
}

@available(macOS 14.0, *)
#Preview("EmpInfoCard — Large Value") {
    let card = EmpInfoCard()
    let _ = card.configure(with: .init(
        common: CommonViewModel(
            corners: .init(radius: 12),
            layoutMargins: NSEdgeInsets(
                top: EmpSpacing.m.rawValue,
                left: EmpSpacing.m.rawValue,
                bottom: EmpSpacing.m.rawValue,
                right: EmpSpacing.m.rawValue
            )
        ),
        subtitle: "Apps Used",
        value: "10"
    ))
    card
}
