import AppKit

public final class ESlider: NSView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel()

    // MARK: - Callback

    public var onValueChanged: ((Double) -> Void)?

    // MARK: - UI Elements

    private let slider: NSSlider = {
        let slider = NSSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.sliderType = .linear
        return slider
    }()

    // MARK: - State

    private var currentStep: Double?

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
        addSubview(slider)

        let guide = empLayoutMarginsGuide
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            slider.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])

        slider.target = self
        slider.action = #selector(sliderValueChanged(_:))
        slider.isContinuous = true
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)

        currentStep = viewModel.step

        slider.minValue = viewModel.minimumValue
        slider.maxValue = viewModel.maximumValue
        slider.doubleValue = viewModel.value
        slider.isEnabled = viewModel.isEnabled

        slider.trackFillColor = viewModel.trackColor

        invalidateIntrinsicContentSize()
        return self
    }

    // MARK: - Actions

    @objc private func sliderValueChanged(_ sender: NSSlider) {
        var value = sender.doubleValue

        if let step = currentStep, step > 0 {
            let min = sender.minValue
            value = (((value - min) / step).rounded() * step) + min
            value = Swift.min(Swift.max(value, sender.minValue), sender.maxValue)
            sender.doubleValue = value
        }

        onValueChanged?(value)
    }

    // MARK: - Layout

    override public var intrinsicContentSize: NSSize {
        let margins = empLayoutMargins
        let sliderHeight = slider.intrinsicContentSize.height
        let height = sliderHeight + margins.top + margins.bottom
        return NSSize(width: NSView.noIntrinsicMetric, height: height)
    }
}
