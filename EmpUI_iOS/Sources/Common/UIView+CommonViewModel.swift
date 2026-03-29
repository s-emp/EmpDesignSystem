import UIKit

extension UIView {
    func apply(common viewModel: CommonViewModel) {
        // Background
        backgroundColor = viewModel.backgroundColor

        // Layout margins
        layoutMargins = viewModel.layoutMargins

        // Corners
        layer.cornerRadius = viewModel.corners.radius
        layer.maskedCorners = viewModel.corners.maskedCorners

        // Border
        switch viewModel.border.style {
        case .solid:
            removeDashedBorder()
            layer.borderWidth = viewModel.border.width
            layer.borderColor = viewModel.border.color.cgColor
        case .dashed:
            layer.borderWidth = 0
            applyDashedBorder(
                width: viewModel.border.width,
                color: viewModel.border.color,
                cornerRadius: viewModel.corners.radius
            )
        }

        // Shadow
        layer.shadowColor = viewModel.shadow.color.cgColor
        layer.shadowOffset = viewModel.shadow.offset
        layer.shadowRadius = viewModel.shadow.radius
        layer.shadowOpacity = viewModel.shadow.opacity

        // clipsToBounds must be false for shadow to render
        if viewModel.shadow.opacity > 0 {
            clipsToBounds = false
            layer.masksToBounds = false
        } else if viewModel.corners.radius > 0 {
            clipsToBounds = true
        }

        // Size
        applySize(viewModel.size)
    }

    // MARK: - Size Helpers

    private func applySize(_ size: SizeViewModel) {
        applySizeDimension(size.width, for: .horizontal)
        applySizeDimension(size.height, for: .vertical)
    }

    private func applySizeDimension(_ dimension: SizeDimension, for axis: NSLayoutConstraint.Axis) {
        let identifierSuffix = axis == .horizontal ? "width" : "height"

        if let existing = constraints.first(where: {
            ($0.firstAttribute == (axis == .horizontal ? .width : .height))
                && $0.secondItem == nil
                && $0.identifier == "EDS.fixed.\(identifierSuffix)"
        }) {
            existing.isActive = false
            removeConstraint(existing)
        }

        switch dimension {
        case .hug:
            setContentHuggingPriority(UILayoutPriority(751), for: axis)
            setContentCompressionResistancePriority(UILayoutPriority(752), for: axis)
        case .fill:
            setContentHuggingPriority(UILayoutPriority(1), for: axis)
            setContentCompressionResistancePriority(UILayoutPriority(752), for: axis)
        case .fixed(let value):
            setContentHuggingPriority(UILayoutPriority(751), for: axis)
            setContentCompressionResistancePriority(UILayoutPriority(752), for: axis)
            let constraint = axis == .horizontal
                ? widthAnchor.constraint(equalToConstant: value)
                : heightAnchor.constraint(equalToConstant: value)
            constraint.priority = .required
            constraint.identifier = "EDS.fixed.\(identifierSuffix)"
            constraint.isActive = true
        }
    }

    // MARK: - Dashed Border Helpers

    private static var dashedBorderLayerKey: UInt8 = 0

    private var dashedBorderLayer: CAShapeLayer? {
        get { objc_getAssociatedObject(self, &UIView.dashedBorderLayerKey) as? CAShapeLayer }
        set { objc_setAssociatedObject(self, &UIView.dashedBorderLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private func applyDashedBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        removeDashedBorder()

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [6, 4]
        shapeLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
        shapeLayer.frame = bounds

        layer.addSublayer(shapeLayer)
        dashedBorderLayer = shapeLayer
    }

    private func removeDashedBorder() {
        dashedBorderLayer?.removeFromSuperlayer()
        dashedBorderLayer = nil
    }
}
