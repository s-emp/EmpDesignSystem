import UIKit

public final class ESlider: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callback

    public var onValueChanged: ((Double) -> Void)?

    // MARK: - UI Elements

    private let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    // MARK: - State

    private var currentStep: Double?

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
        addSubview(slider)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            slider.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])

        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        currentStep = viewModel.step

        slider.minimumValue = Float(viewModel.minimumValue)
        slider.maximumValue = Float(viewModel.maximumValue)
        slider.value = Float(viewModel.value)
        slider.isEnabled = viewModel.isEnabled

        slider.minimumTrackTintColor = viewModel.minimumTrackColor
        slider.maximumTrackTintColor = viewModel.maximumTrackColor
        slider.thumbTintColor = viewModel.thumbColor

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Actions

    @objc private func sliderValueChanged(_ sender: UISlider) {
        var value = Double(sender.value)

        if let step = currentStep, step > 0 {
            let min = Double(sender.minimumValue)
            value = (((value - min) / step).rounded() * step) + min
            value = Swift.min(Swift.max(value, Double(sender.minimumValue)), Double(sender.maximumValue))
            sender.value = Float(value)
        }

        onValueChanged?(value)
    }

    // MARK: - Layout

    override public var intrinsicContentSize: CGSize {
        let margins = layoutMargins
        let sliderHeight = slider.intrinsicContentSize.height
        let height = sliderHeight + margins.top + margins.bottom
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}
