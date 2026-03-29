import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("ESegmentControl — 2 сегмента") {
    let control = ESegmentControl()
    let _ = control.configure(with: ESegmentControl.Preset.default(segments: ["Day", "Week"]))
    control
}

@available(macOS 14.0, *)
#Preview("ESegmentControl — 3 сегмента") {
    let control = ESegmentControl()
    let _ = control.configure(with: ESegmentControl.Preset.default(segments: ["Day", "Week", "Month"]))
    control
}

@available(macOS 14.0, *)
#Preview("ESegmentControl — Второй выбран") {
    let control = ESegmentControl()
    let _ = control.configure(with: ESegmentControl.Preset.default(segments: ["Day", "Week"]))
    let _ = control.select(index: 1)
    control
}

@available(macOS 14.0, *)
#Preview("ESegmentControl — Кастомный цвет") {
    let control = ESegmentControl()
    let _ = control.configure(with: .init(
        segments: ["On", "Off"],
        selectedSegmentTintColor: .systemBlue
    ))
    control
}
