import UIKit

public final class EAnimationView: UIView, EComponent {
    // MARK: - EComponent

    public private(set) var viewModel: ViewModel = ViewModel(animationName: "", size: .zero)

    // MARK: - Animation Provider

    private var animationProvider: AnimationProvider?
    private var animationContentView: UIView?

    // MARK: - Placeholder

    private let placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Constraints

    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?

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
        addSubview(placeholderView)

        let guide = layoutMarginsGuide
        let wc = placeholderView.widthAnchor.constraint(equalToConstant: 0)
        let hc = placeholderView.heightAnchor.constraint(equalToConstant: 0)
        widthConstraint = wc
        heightConstraint = hc

        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: guide.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            wc,
            hc,
        ])
    }

    // MARK: - Configure

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        self.viewModel = viewModel
        apply(common: viewModel.common)
        clipsToBounds = true

        widthConstraint?.constant = viewModel.size.width
        heightConstraint?.constant = viewModel.size.height

        if let provider = animationProvider {
            provider.play(loopMode: viewModel.loopMode)
        }

        return self
    }

    // MARK: - Animation Provider

    /// Регистрирует провайдер анимации. Вызывать до `configure(with:)`.
    public func setAnimationProvider(_ provider: AnimationProvider) {
        animationContentView?.removeFromSuperview()

        animationProvider = provider
        let contentView = provider.makeView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        animationContentView = contentView

        placeholderView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: placeholderView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: placeholderView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: placeholderView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: placeholderView.bottomAnchor),
        ])
    }

    /// Запускает анимацию (если провайдер зарегистрирован)
    public func play() {
        animationProvider?.play(loopMode: viewModel.loopMode)
    }

    /// Останавливает анимацию
    public func stop() {
        animationProvider?.stop()
    }

    /// Устанавливает прогресс анимации (0.0–1.0)
    public func setProgress(_ progress: CGFloat) {
        animationProvider?.setProgress(progress)
    }
}
