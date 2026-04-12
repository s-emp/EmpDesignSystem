import Cocoa
import EmpUI_macOS

final class MainWindowController: NSWindowController {
    private let splitView = ESplitView()
    private let sidebarBuilder = SidebarBuilder()
    private let previewBuilder = PreviewBuilder()
    private let inspectorBuilder = InspectorBuilder()
    private var currentPage: ComponentPage?
    private var inspectorPanel: NSView?

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
        inspectorPanel = inspector

        splitView.addPanel(sidebar, minSize: 200, maxSize: 300, holdingPriority: .init(260))
        splitView.addPanel(preview, minSize: 400, holdingPriority: .init(200))
        splitView.addPanel(inspector, minSize: 260, maxSize: 400, holdingPriority: .init(260))

        sidebarBuilder.onItemSelected = { [weak self] item in
            self?.handleItemSelected(item)
        }

        window?.contentView = splitView

        // Set initial divider positions after layout
        DispatchQueue.main.async { [weak self] in
            self?.splitView.setDividerPosition(220, at: 0)
            self?.splitView.setDividerPosition(1200 - 280, at: 1)
        }
    }

    private func handleItemSelected(_ item: CatalogItem) {
        // Token pages — no inspector, just showcase
        if TokenPages.isTokenPage(item.id) {
            currentPage = nil
            if let tokenView = TokenPages.makePage(for: item.id) {
                previewBuilder.showComponent(name: item.name, view: tokenView)
            } else {
                previewBuilder.showComponent(
                    name: "\(item.name) (coming soon)",
                    view: makePlaceholder(for: item)
                )
            }
            updateInspectorWithText("Token showcase")
            return
        }

        guard let page = ComponentFactory.makePage(for: item.id) else {
            previewBuilder.showComponent(
                name: "\(item.name) (coming soon)",
                view: makePlaceholder(for: item)
            )
            currentPage = nil
            updateInspector(for: item, viewModel: nil)
            return
        }
        currentPage = page
        previewBuilder.showComponent(name: item.name, view: page.component)
        updateInspector(for: item, viewModel: page.defaultViewModel)
    }

    private func updateInspector(for item: CatalogItem, viewModel: Any?) {
        guard let panel = inspectorPanel else { return }

        // Remove old inspector content
        for subview in panel.subviews {
            subview.removeFromSuperview()
        }

        guard let vm = viewModel else {
            // Show placeholder for unknown components
            let placeholder = makePanel(title: "Inspector", color: .Semantic.backgroundSecondary)
            placeholder.translatesAutoresizingMaskIntoConstraints = false
            panel.addSubview(placeholder)
            NSLayoutConstraint.activate([
                placeholder.topAnchor.constraint(equalTo: panel.topAnchor),
                placeholder.leadingAnchor.constraint(equalTo: panel.leadingAnchor),
                placeholder.trailingAnchor.constraint(equalTo: panel.trailingAnchor),
                placeholder.bottomAnchor.constraint(equalTo: panel.bottomAnchor),
            ])
            return
        }

        inspectorBuilder.onViewModelChanged = { [weak self] newVM in
            guard let self, let page = self.currentPage else { return }
            page.configure(page.component, newVM)
        }

        let inspectorView = inspectorBuilder.build(for: item, viewModel: vm)
        inspectorView.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(inspectorView)
        NSLayoutConstraint.activate([
            inspectorView.topAnchor.constraint(equalTo: panel.topAnchor),
            inspectorView.leadingAnchor.constraint(equalTo: panel.leadingAnchor),
            inspectorView.trailingAnchor.constraint(equalTo: panel.trailingAnchor),
            inspectorView.bottomAnchor.constraint(equalTo: panel.bottomAnchor),
        ])
    }

    private func updateInspectorWithText(_ text: String) {
        guard let panel = inspectorPanel else { return }
        for subview in panel.subviews {
            subview.removeFromSuperview()
        }
        let placeholder = makePanel(title: text, color: .Semantic.backgroundSecondary)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        panel.addSubview(placeholder)
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo: panel.topAnchor),
            placeholder.leadingAnchor.constraint(equalTo: panel.leadingAnchor),
            placeholder.trailingAnchor.constraint(equalTo: panel.trailingAnchor),
            placeholder.bottomAnchor.constraint(equalTo: panel.bottomAnchor),
        ])
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
