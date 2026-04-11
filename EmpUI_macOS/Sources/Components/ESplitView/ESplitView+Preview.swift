import AppKit
import SwiftUI

@available(macOS 14.0, *)
#Preview("ESplitView — Horizontal") {
    let splitView = ESplitView(frame: NSRect(x: 0, y: 0, width: 600, height: 400))
    let _ = splitView.configure(with: .init(orientation: .horizontal))

    let left = NSView()
    let _ = { left.wantsLayer = true; left.layer?.backgroundColor = NSColor.systemBlue.withAlphaComponent(0.3).cgColor }()

    let right = NSView()
    let _ = { right.wantsLayer = true; right.layer?.backgroundColor = NSColor.systemGreen.withAlphaComponent(0.3).cgColor }()

    let _ = splitView.addPanel(left, minSize: 100, maxSize: nil)
    let _ = splitView.addPanel(right, minSize: 100, maxSize: nil)
    splitView
}

@available(macOS 14.0, *)
#Preview("ESplitView — Vertical") {
    let splitView = ESplitView(frame: NSRect(x: 0, y: 0, width: 600, height: 400))
    let _ = splitView.configure(with: .init(orientation: .vertical))

    let top = NSView()
    let _ = { top.wantsLayer = true; top.layer?.backgroundColor = NSColor.systemOrange.withAlphaComponent(0.3).cgColor }()

    let bottom = NSView()
    let _ = { bottom.wantsLayer = true; bottom.layer?.backgroundColor = NSColor.systemPurple.withAlphaComponent(0.3).cgColor }()

    let _ = splitView.addPanel(top, minSize: 80, maxSize: nil)
    let _ = splitView.addPanel(bottom, minSize: 80, maxSize: nil)
    splitView
}

@available(macOS 14.0, *)
#Preview("ESplitView — Three Panels") {
    let splitView = ESplitView(frame: NSRect(x: 0, y: 0, width: 800, height: 400))
    let _ = splitView.configure(with: .init(orientation: .horizontal, dividerStyle: .thick))

    let left = NSView()
    let _ = { left.wantsLayer = true; left.layer?.backgroundColor = NSColor.systemRed.withAlphaComponent(0.3).cgColor }()

    let center = NSView()
    let _ = { center.wantsLayer = true; center.layer?.backgroundColor = NSColor.systemYellow.withAlphaComponent(0.3).cgColor }()

    let right = NSView()
    let _ = { right.wantsLayer = true; right.layer?.backgroundColor = NSColor.systemTeal.withAlphaComponent(0.3).cgColor }()

    let _ = splitView.addPanel(left, minSize: 150, maxSize: 250)
    let _ = splitView.addPanel(center, minSize: 200, maxSize: nil)
    let _ = splitView.addPanel(right, minSize: 150, maxSize: nil)
    splitView
}
