import AppKit

public final class EListContainer: NSView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    private static let cellIdentifier = NSUserInterfaceItemIdentifier("EListContainerCell")

    private lazy var scrollView: NSScrollView = {
        let sv = NSScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.drawsBackground = false
        sv.documentView = collectionView
        return sv
    }()

    private lazy var collectionView: NSCollectionView = {
        let cv = NSCollectionView()
        cv.collectionViewLayout = makeLayout()
        cv.backgroundColors = [.clear]
        cv.dataSource = self
        cv.register(ECollectionCell.self, forItemWithIdentifier: Self.cellIdentifier)
        return cv
    }()

    private var items: [ComponentDescriptor] = []

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupCollectionView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public func configure(with viewModel: ViewModel) -> Self {
        let axisChanged = self.viewModel.axis != viewModel.axis
        let spacingChanged = self.viewModel.spacing != viewModel.spacing
        self.viewModel = viewModel
        apply(common: viewModel.common)
        if axisChanged || spacingChanged {
            collectionView.collectionViewLayout = makeLayout()
        }
        return self
    }

    public func setItems(_ items: [ComponentDescriptor]) {
        self.items = items
        collectionView.reloadData()
    }

    // MARK: - Private

    private func setupCollectionView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: empLayoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: empLayoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: empLayoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: empLayoutMarginsGuide.bottomAnchor),
        ])
    }

    private func makeLayout() -> NSCollectionViewFlowLayout {
        let layout = NSCollectionViewFlowLayout()
        layout.scrollDirection = viewModel.axis == .vertical ? .vertical : .horizontal
        layout.minimumLineSpacing = viewModel.spacing
        layout.minimumInteritemSpacing = viewModel.spacing
        layout.estimatedItemSize = NSSize(width: 100, height: 44)
        return layout
    }
}

// MARK: - NSCollectionViewDataSource

extension EListContainer: NSCollectionViewDataSource {
    public func collectionView(_: NSCollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    public func collectionView(
        _ collectionView: NSCollectionView,
        itemForRepresentedObjectAt indexPath: IndexPath
    ) -> NSCollectionViewItem {
        let item = collectionView.makeItem(
            withIdentifier: Self.cellIdentifier,
            for: indexPath
        )
        if let eCell = item as? ECollectionCell {
            eCell.configure(with: items[indexPath.item])
        }
        return item
    }
}
