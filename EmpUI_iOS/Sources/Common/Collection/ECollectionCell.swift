import UIKit

public final class ECollectionCell: UICollectionViewCell {
    private var rootView: UIView?
    private var currentFingerprint: StructureFingerprint?

    public func configure(with descriptor: ComponentDescriptor) {
        let fp = descriptor.fingerprint

        if fp == currentFingerprint, let root = rootView {
            ComponentBuilder.update(view: root, with: descriptor)
        } else {
            rootView?.removeFromSuperview()

            let view = ComponentBuilder.build(from: descriptor)
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: contentView.topAnchor),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])

            rootView = view
            currentFingerprint = fp
        }
    }

}
