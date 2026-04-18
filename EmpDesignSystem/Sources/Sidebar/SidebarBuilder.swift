import Cocoa
import EmpUI_macOS

@MainActor
final class SidebarBuilder {

    var onItemSelected: ((CatalogItem) -> Void)?

    private let scroll = EScroll()
    private let stack = EStack()
    private var rowContainers: [String: ETapContainer] = [:]
    private var selectedItemId: String?

    func build() -> NSView {
        let _ = scroll.configure(with: .init(
            common: .init(backgroundColor: .Semantic.backgroundSecondary),
            orientation: .vertical,
            showsIndicators: true
        ))

        let _ = stack.configure(with: .init(
            common: .init(backgroundColor: .Semantic.backgroundSecondary),
            orientation: .vertical,
            spacing: 0,
            alignment: .leading,
            distribution: .fill
        ))

        let groups = CatalogItem.grouped()
        for (index, group) in groups.enumerated() {
            if index > 0 {
                let divider = EDivider()
                let _ = divider.configure(with: .init(
                    common: .init(layoutMargins: NSEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
                ))
                stack.addArrangedSubview(divider)
            }

            let header = EText()
            let _ = header.configure(with: .init(
                common: .init(layoutMargins: NSEdgeInsets(top: 16, left: 16, bottom: 4, right: 16)),
                content: .plain(.init(
                    text: group.category.rawValue.uppercased(),
                    font: .systemFont(ofSize: 11, weight: .semibold),
                    color: .Semantic.textSecondary
                ))
            ))
            stack.addArrangedSubview(header)

            for item in group.items {
                let row = makeRow(for: item)
                stack.addArrangedSubview(row)
            }
        }

        scroll.documentView = stack
        stack.translatesAutoresizingMaskIntoConstraints = false

        if let contentView = scroll.contentView as? NSClipView {
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: contentView.topAnchor),
                stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        }

        // Right border to separate from preview panel
        let rightBorder = NSView()
        rightBorder.wantsLayer = true
        rightBorder.layer?.backgroundColor = NSColor.Semantic.borderSubtle.cgColor
        rightBorder.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(rightBorder)
        NSLayoutConstraint.activate([
            rightBorder.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            rightBorder.topAnchor.constraint(equalTo: scroll.topAnchor),
            rightBorder.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            rightBorder.widthAnchor.constraint(equalToConstant: 1),
        ])

        return scroll
    }

    func selectItem(_ itemId: String) {
        guard let item = CatalogItem.all.first(where: { $0.id == itemId }) else { return }
        applySelection(itemId: itemId)
        onItemSelected?(item)
    }

    // MARK: - Private

    private func makeRow(for item: CatalogItem) -> ETapContainer {
        let label = EText()
        let _ = label.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)),
            content: .plain(.init(
                text: item.name,
                font: .systemFont(ofSize: 13),
                color: .Semantic.textPrimary
            ))
        ))

        let container = ETapContainer()
        let _ = container.configure(with: .init(
            action: .init(id: item.id, handler: { [weak self] _ in
                self?.applySelection(itemId: item.id)
                self?.onItemSelected?(item)
            })
        ))
        container.setContent(label)

        rowContainers[item.id] = container
        return container
    }

    func applySelection(itemId: String) {
        if let previousId = selectedItemId, let previousContainer = rowContainers[previousId] {
            let _ = previousContainer.configure(with: .init(
                common: .init(backgroundColor: .clear),
                action: previousContainer.viewModel.action
            ))
        }

        selectedItemId = itemId

        if let container = rowContainers[itemId] {
            let _ = container.configure(with: .init(
                common: .init(
                    corners: .init(radius: 6),
                    backgroundColor: .Semantic.actionPrimaryTint
                ),
                action: container.viewModel.action
            ))
        }
    }
}
