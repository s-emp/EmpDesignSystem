import Cocoa
import EmpUI_macOS

final class MainWindowController: NSWindowController {
    private let splitView = ESplitView()
    private let sidebarBuilder = SidebarBuilder()
    private let previewBuilder = PreviewBuilder()
    private var currentPage: ComponentPage?

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

        let sidebar = sidebarBuilder.build()
        let preview = previewBuilder.build()
        let inspector = makePanel(title: "Inspector", color: .Semantic.backgroundSecondary)

        let _ = splitView.addPanel(sidebar, minSize: 200, maxSize: 300)
        let _ = splitView.addPanel(preview, minSize: 400)
        let _ = splitView.addPanel(inspector, minSize: 260, maxSize: 400)

        sidebarBuilder.onItemSelected = { [weak self] item in
            self?.handleItemSelected(item)
        }

        window?.contentView = splitView
    }

    private func handleItemSelected(_ item: CatalogItem) {
        guard let page = ComponentFactory.makePage(for: item.id) else {
            previewBuilder.showComponent(
                name: "\(item.name) (coming soon)",
                view: makePlaceholder(for: item)
            )
            currentPage = nil
            return
        }
        currentPage = page
        previewBuilder.showComponent(name: item.name, view: page.component)
    }

    private func makePlaceholder(for item: CatalogItem) -> NSView {
        let label = EText()
        let _ = label.configure(with: .init(
            content: .plain(.init(
                text: "\(item.name) — not yet implemented",
                font: .systemFont(ofSize: 14),
                color: .Semantic.textTertiary
            )),
            alignment: .center
        ))
        return label
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
