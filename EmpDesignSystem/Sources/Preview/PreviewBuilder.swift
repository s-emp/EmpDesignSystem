import Cocoa
import EmpUI_macOS

@MainActor
final class PreviewBuilder {

    private let outerStack = EStack()
    private let headerLabel = EText()
    private let headerDivider = EDivider()
    private let contentContainer = NSView()
    private var currentComponentView: NSView?

    func build() -> NSView {
        let _ = outerStack.configure(with: .init(
            common: .init(backgroundColor: .Semantic.backgroundPrimary),
            orientation: .vertical,
            spacing: 0,
            alignment: .leading,
            distribution: .fill
        ))

        // Header bar
        let headerStack = EStack()
        let _ = headerStack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)),
            orientation: .horizontal,
            spacing: 0
        ))

        let _ = headerLabel.configure(with: .init(
            content: .plain(.init(
                text: "Select a component",
                font: .systemFont(ofSize: 16, weight: .semibold),
                color: .Semantic.textSecondary
            ))
        ))
        headerStack.addArrangedSubview(headerLabel)

        outerStack.addArrangedSubview(headerStack)
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.leadingAnchor.constraint(equalTo: outerStack.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: outerStack.trailingAnchor),
        ])

        let _ = headerDivider.configure(with: .init())
        outerStack.addArrangedSubview(headerDivider)
        headerDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerDivider.leadingAnchor.constraint(equalTo: outerStack.leadingAnchor),
            headerDivider.trailingAnchor.constraint(equalTo: outerStack.trailingAnchor),
        ])

        // Content area — centers the component
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        outerStack.addArrangedSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: outerStack.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: outerStack.trailingAnchor),
        ])

        // Make content area fill remaining vertical space
        contentContainer.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentContainer.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return outerStack
    }

    func showComponent(name: String, view: NSView) {
        let _ = headerLabel.configure(with: .init(
            content: .plain(.init(
                text: name,
                font: .systemFont(ofSize: 16, weight: .semibold),
                color: .Semantic.textPrimary
            ))
        ))

        currentComponentView?.removeFromSuperview()
        currentComponentView = view

        view.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: contentContainer.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            view.leadingAnchor.constraint(greaterThanOrEqualTo: contentContainer.leadingAnchor, constant: 24),
            view.trailingAnchor.constraint(lessThanOrEqualTo: contentContainer.trailingAnchor, constant: -24),
            view.topAnchor.constraint(greaterThanOrEqualTo: contentContainer.topAnchor, constant: 24),
            view.bottomAnchor.constraint(lessThanOrEqualTo: contentContainer.bottomAnchor, constant: -24),
        ])
    }
}
