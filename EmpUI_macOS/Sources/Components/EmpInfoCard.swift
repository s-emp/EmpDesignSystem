import AppKit

public final class EmpInfoCard: NSView {
    // MARK: - UI Elements

    private let subtitleField: NSTextField = {
        let field = NSTextField(labelWithString: "")
        field.isEditable = false
        field.isBordered = false
        field.drawsBackground = false
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return field
    }()

    private let valueField: NSTextField = {
        let field = NSTextField(labelWithString: "")
        field.isEditable = false
        field.isBordered = false
        field.drawsBackground = false
        field.translatesAutoresizingMaskIntoConstraints = false
        field.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return field
    }()

    // MARK: - Background State

    private var currentBackground: Background?
    private var gradientLayer: CAGradientLayer?
    private var currentGradient: EmpGradient?

    // MARK: - Constraints

    private var spacingConstraint: NSLayoutConstraint?

    // MARK: - Init

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        wantsLayer = true
        layer?.cornerCurve = .continuous

        addSubview(subtitleField)
        addSubview(valueField)

        let guide = empLayoutMarginsGuide
        let spacing = subtitleField.bottomAnchor.constraint(
            equalTo: valueField.topAnchor,
            constant: -EmpSpacing.xs.rawValue
        )
        spacingConstraint = spacing

        NSLayoutConstraint.activate([
            subtitleField.topAnchor.constraint(equalTo: guide.topAnchor),
            subtitleField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            subtitleField.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor),

            spacing,

            valueField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            valueField.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor),
            valueField.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        // Spacing
        spacingConstraint?.constant = -viewModel.spacing

        // Subtitle
        subtitleField.stringValue = viewModel.subtitle.uppercased()
        subtitleField.font = viewModel.subtitleFont
        subtitleField.textColor = viewModel.subtitleColor

        // Value
        valueField.stringValue = viewModel.value
        valueField.font = viewModel.valueFont
        valueField.textColor = viewModel.valueColor

        // Background
        applyBackground(viewModel.background)

        invalidateIntrinsicContentSize()
    }

    // MARK: - Background

    private func applyBackground(_ background: Background) {
        currentBackground = background
        switch background {
        case let .color(color):
            removeGradient()
            effectiveAppearance.performAsCurrentDrawingAppearance {
                layer?.backgroundColor = color.cgColor
            }

        case let .gradient(gradient):
            layer?.backgroundColor = nil
            applyGradient(gradient)
        }
    }

    private func applyGradient(_ gradient: EmpGradient) {
        currentGradient = gradient
        if gradientLayer == nil {
            let gl = CAGradientLayer()
            gl.cornerCurve = .continuous
            layer?.insertSublayer(gl, at: 0)
            gradientLayer = gl
        }
        let resolved = gradient.resolvedColors(for: effectiveAppearance)
        gradientLayer?.colors = [resolved.start, resolved.end]
        gradientLayer?.startPoint = .zero
        gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer?.cornerRadius = layer?.cornerRadius ?? 0
        gradientLayer?.maskedCorners = layer?.maskedCorners ?? []
    }

    private func removeGradient() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        currentGradient = nil
    }

    // MARK: - Layout

    override public func layout() {
        super.layout()
        gradientLayer?.frame = bounds
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: NSSize {
        let margins = empLayoutMargins
        let subtitleSize = subtitleField.intrinsicContentSize
        let valueSize = valueField.intrinsicContentSize
        let spacing = spacingConstraint.map { -$0.constant } ?? EmpSpacing.xs.rawValue

        let width = max(subtitleSize.width, valueSize.width) + margins.left + margins.right
        let height = subtitleSize.height + spacing + valueSize.height + margins.top + margins.bottom

        return NSSize(width: width, height: height)
    }

    // MARK: - Appearance

    override public func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        guard let background = currentBackground else { return }
        switch background {
        case let .color(color):
            effectiveAppearance.performAsCurrentDrawingAppearance {
                layer?.backgroundColor = color.cgColor
            }
        case let .gradient(gradient):
            let resolved = gradient.resolvedColors(for: effectiveAppearance)
            gradientLayer?.colors = [resolved.start, resolved.end]
        }
    }
}
