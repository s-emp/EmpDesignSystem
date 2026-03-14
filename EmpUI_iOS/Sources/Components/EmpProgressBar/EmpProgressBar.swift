import UIKit

public final class EmpProgressBar: UIView {
    // MARK: - ViewModel

    public struct ViewModel {
        // MARK: Public

        public let common: CommonViewModel
        public let progress: CGFloat
        public let trackColor: UIColor
        public let fillColor: UIColor
        public let barHeight: CGFloat

        public init(
            common: CommonViewModel = CommonViewModel(),
            progress: CGFloat = 0,
            trackColor: UIColor = UIColor.Semantic.backgroundTertiary,
            fillColor: UIColor = UIColor.Semantic.actionPrimary,
            barHeight: CGFloat = 4
        ) {
            self.common = common
            self.progress = min(max(progress, 0), 1)
            self.trackColor = trackColor
            self.fillColor = fillColor
            self.barHeight = barHeight
        }
    }

    // MARK: - UI Elements

    private let trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let fillView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Constraints

    private var trackHeightConstraint: NSLayoutConstraint?
    private var fillWidthConstraint: NSLayoutConstraint?

    // MARK: - State

    private var currentProgress: CGFloat = 0

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
        addSubview(trackView)
        trackView.addSubview(fillView)

        let guide = layoutMarginsGuide
        let heightConstraint = trackView.heightAnchor.constraint(equalToConstant: 4)
        trackHeightConstraint = heightConstraint

        let widthConstraint = fillView.widthAnchor.constraint(equalToConstant: 0)
        fillWidthConstraint = widthConstraint

        NSLayoutConstraint.activate([
            trackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            trackView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            heightConstraint,

            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.topAnchor.constraint(equalTo: trackView.topAnchor),
            fillView.bottomAnchor.constraint(equalTo: trackView.bottomAnchor),
            widthConstraint,
        ])
    }

    // MARK: - Configure

    public func configure(with viewModel: ViewModel) {
        apply(common: viewModel.common)

        currentProgress = viewModel.progress

        trackView.backgroundColor = viewModel.trackColor
        fillView.backgroundColor = viewModel.fillColor

        let cornerRadius = viewModel.barHeight / 2
        trackView.layer.cornerRadius = cornerRadius
        fillView.layer.cornerRadius = cornerRadius
        trackView.clipsToBounds = true

        trackHeightConstraint?.constant = viewModel.barHeight
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()
        let trackWidth = trackView.bounds.width
        fillWidthConstraint?.constant = trackWidth * currentProgress
    }

    override public var intrinsicContentSize: CGSize {
        let margins = layoutMargins
        let height = (trackHeightConstraint?.constant ?? 4) + margins.top + margins.bottom
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
}
