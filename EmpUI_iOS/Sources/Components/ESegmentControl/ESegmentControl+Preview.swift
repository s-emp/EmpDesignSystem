import SwiftUI
import UIKit

@available(iOS 17.0, *)
#Preview("ESegmentControl — 2 сегмента") {
    let control = ESegmentControl()
    let _ = control.configure(with: ESegmentControl.Preset.default(segments: ["Day", "Week"]))
    control
}

@available(iOS 17.0, *)
#Preview("ESegmentControl — 3 сегмента") {
    let control = ESegmentControl()
    let _ = control.configure(with: ESegmentControl.Preset.default(segments: ["Day", "Week", "Month"]))
    control
}

@available(iOS 17.0, *)
#Preview("ESegmentControl — Второй выбран") {
    let control = ESegmentControl()
    let _ = control.configure(with: ESegmentControl.Preset.default(segments: ["Day", "Week"]))
    let _ = control.select(index: 1)
    control
}

@available(iOS 17.0, *)
#Preview("ESegmentControl — Кастомный цвет") {
    let control = ESegmentControl()
    let _ = control.configure(with: .init(
        segments: ["On", "Off"],
        selectedSegmentTintColor: .systemBlue
    ))
    control
}
