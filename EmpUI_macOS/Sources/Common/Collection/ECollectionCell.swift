import AppKit

public final class ECollectionCell: NSCollectionViewItem {
    private var rootView: NSView?
    private var currentFingerprint: StructureFingerprint?

    public func configure(with descriptor: ComponentDescriptor) {
        let fp = descriptor.fingerprint

        if fp == currentFingerprint, let root = rootView {
            ComponentBuilder.update(view: root, with: descriptor)
        } else {
            rootView?.removeFromSuperview()

            let container = view
            let newView = ComponentBuilder.build(from: descriptor)
            newView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(newView)
            NSLayoutConstraint.activate([
                newView.topAnchor.constraint(equalTo: container.topAnchor),
                newView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                newView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                newView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            ])

            rootView = newView
            currentFingerprint = fp
        }
    }

    override public func loadView() {
        view = NSView()
    }
}
