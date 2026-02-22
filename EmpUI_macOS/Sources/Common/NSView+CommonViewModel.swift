import AppKit

extension NSView {

    func apply(common viewModel: CommonViewModel) {
        wantsLayer = true
        guard let layer = layer else { return }

        // Background
        layer.backgroundColor = viewModel.backgroundColor.cgColor

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
        shadow = NSShadow()
        layer.shadowColor = viewModel.shadow.color.cgColor
        layer.shadowOffset = viewModel.shadow.offset
        layer.shadowRadius = viewModel.shadow.radius
        layer.shadowOpacity = viewModel.shadow.opacity
    }

    // MARK: - Dashed Border Helpers

    private static var dashedBorderLayerKey: UInt8 = 0

    private var dashedBorderLayer: CAShapeLayer? {
        get { objc_getAssociatedObject(self, &NSView.dashedBorderLayerKey) as? CAShapeLayer }
        set { objc_setAssociatedObject(self, &NSView.dashedBorderLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private func applyDashedBorder(width: CGFloat, color: NSColor, cornerRadius: CGFloat) {
        removeDashedBorder()
        wantsLayer = true

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [6, 4]
        shapeLayer.path = CGPath(
            roundedRect: bounds,
            cornerWidth: cornerRadius,
            cornerHeight: cornerRadius,
            transform: nil
        )
        shapeLayer.frame = bounds

        layer?.addSublayer(shapeLayer)
        dashedBorderLayer = shapeLayer
    }

    private func removeDashedBorder() {
        dashedBorderLayer?.removeFromSuperlayer()
        dashedBorderLayer = nil
    }
}
