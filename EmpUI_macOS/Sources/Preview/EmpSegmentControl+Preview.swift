import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("EmpSegmentControl — 2 сегмента") {
    let control = EmpSegmentControl()
    let _ = control.configure(with: EmpSegmentControl.Preset.default(segments: ["Day", "Week"]))
    control
}

@available(macOS 14.0, *)
#Preview("EmpSegmentControl — 3 сегмента") {
    let control = EmpSegmentControl()
    let _ = control.configure(with: EmpSegmentControl.Preset.default(segments: ["Day", "Week", "Month"]))
    control
}

@available(macOS 14.0, *)
#Preview("EmpSegmentControl — Второй выбран") {
    let control = EmpSegmentControl()
    let _ = control.configure(with: EmpSegmentControl.Preset.default(segments: ["Day", "Week"]))
    let _ = control.select(index: 1)
    control
}

@available(macOS 14.0, *)
#Preview("EmpSegmentControl — Кастомный цвет") {
    let control = EmpSegmentControl()
    let _ = control.configure(with: .init(
        segments: ["On", "Off"],
        selectedSegmentTintColor: .systemBlue
    ))
    control
}
