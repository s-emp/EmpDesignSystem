import UIKit

public final class EmpInfoCard: UIView {
    // MARK: - UI Elements

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Gradient

    private var gradientLayer: CAGradientLayer?
    private var currentGradient: EmpGradient?

    // MARK: - Constraints

    private var spacingConstraint: NSLayoutConstraint?

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerCurve = .continuous

        addSubview(subtitleLabel)
        addSubview(valueLabel)

        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: EmpInfoCard, _: UITraitCollection) in
            if let gradient = view.currentGradient {
                let resolved = gradient.resolvedColors(for: view.traitCollection)
                view.gradientLayer?.colors = [resolved.start, resolved.end]
            }
        }

        let guide = layoutMarginsGuide
        let spacing = subtitleLabel.bottomAnchor.constraint(
            equalTo: valueLabel.topAnchor,
            constant: -EmpSpacing.xs.rawValue
        )
        spacingConstraint = spacing

        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: guide.topAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor),

            spacing,

            valueLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        // Spacing
        spacingConstraint?.constant = -viewModel.spacing

        // Subtitle
        subtitleLabel.text = viewModel.subtitle.uppercased()
        subtitleLabel.font = viewModel.subtitleFont
        subtitleLabel.textColor = viewModel.subtitleColor

        // Value
        valueLabel.text = viewModel.value
        valueLabel.font = viewModel.valueFont
        valueLabel.textColor = viewModel.valueColor

        // Background
        applyBackground(viewModel.background)

        invalidateIntrinsicContentSize()
    }

    // MARK: - Background

    private func applyBackground(_ background: Background) {
        switch background {
        case let .color(color):
            removeGradient()
            backgroundColor = color

        case let .gradient(gradient):
            backgroundColor = .clear
            applyGradient(gradient)
        }
    }

    private func applyGradient(_ gradient: EmpGradient) {
        currentGradient = gradient
        if gradientLayer == nil {
            let gl = CAGradientLayer()
            gl.cornerCurve = .continuous
            layer.insertSublayer(gl, at: 0)
            gradientLayer = gl
        }
        let resolved = gradient.resolvedColors(for: traitCollection)
        gradientLayer?.colors = [resolved.start, resolved.end]
        gradientLayer?.startPoint = .zero
        gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer?.cornerRadius = layer.cornerRadius
        gradientLayer?.maskedCorners = layer.maskedCorners
    }

    private func removeGradient() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
        currentGradient = nil
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let margins = layoutMargins
        let subtitleSize = subtitleLabel.intrinsicContentSize
        let valueSize = valueLabel.intrinsicContentSize
        let spacing = spacingConstraint.map { -$0.constant } ?? EmpSpacing.xs.rawValue

        let width = max(subtitleSize.width, valueSize.width) + margins.left + margins.right
        let height = subtitleSize.height + spacing + valueSize.height + margins.top + margins.bottom

        return CGSize(width: width, height: height)
    }
}
