import Cocoa
import EmpUI_macOS

final class MainWindowController: NSWindowController {
    private let splitView = ESplitView()

    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1200, height: 800),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "EmpDesignSystem — Brandbook"
        window.center()
        super.init(window: window)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let _ = splitView.configure(with: .init(
            orientation: .horizontal,
            dividerStyle: .thin
        ))

        let sidebar = makePanel(title: "Sidebar", color: .Semantic.backgroundSecondary)
        let preview = makePanel(title: "Preview", color: .Semantic.backgroundPrimary)
        let inspector = makePanel(title: "Inspector", color: .Semantic.backgroundSecondary)

        let _ = splitView.addPanel(sidebar, minSize: 200, maxSize: 300)
        let _ = splitView.addPanel(preview, minSize: 400)
        let _ = splitView.addPanel(inspector, minSize: 260, maxSize: 400)

        window?.contentView = splitView
    }

    private func makePanel(title: String, color: NSColor) -> NSView {
        let text = EText()
        let _ = text.configure(with: .init(
            content: .plain(.init(text: title, color: .Semantic.textSecondary)),
            alignment: .center
        ))

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(backgroundColor: color),
            orientation: .vertical
        ))
        stack.addArrangedSubview(text)

        return stack
    }
}
