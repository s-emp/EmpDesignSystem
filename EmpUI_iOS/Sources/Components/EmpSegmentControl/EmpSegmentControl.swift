import UIKit

public final class EmpSegmentControl: UIView {
    // MARK: - Action

    public var onSelectionChanged: ((Int) -> Void)?

    // MARK: - State

    public private(set) var selectedIndex: Int = 0

    // MARK: - UI Elements

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

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
        addSubview(segmentedControl)

        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: guide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])

        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        segmentedControl.removeAllSegments()
        for (index, title) in viewModel.segments.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }

        let attributes: [NSAttributedString.Key: Any] = [.font: viewModel.font]
        segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        segmentedControl.setTitleTextAttributes(attributes, for: .selected)

        segmentedControl.selectedSegmentTintColor = viewModel.selectedSegmentTintColor

        selectedIndex = 0
        segmentedControl.selectedSegmentIndex = 0
        invalidateIntrinsicContentSize()
    }

    // MARK: - Selection

    public func select(index: Int) {
        guard index >= 0, index < segmentedControl.numberOfSegments, index != selectedIndex else { return }
        selectedIndex = index
        segmentedControl.selectedSegmentIndex = index
    }

    // MARK: - Action Handler

    @objc
    private func segmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        guard index != selectedIndex else { return }
        selectedIndex = index
        onSelectionChanged?(index)
    }

    // MARK: - Intrinsic Content Size

    override public var intrinsicContentSize: CGSize {
        let margins = layoutMargins
        let controlSize = segmentedControl.intrinsicContentSize

        return CGSize(
            width: controlSize.width + margins.left + margins.right,
            height: controlSize.height + margins.top + margins.bottom
        )
    }
}
