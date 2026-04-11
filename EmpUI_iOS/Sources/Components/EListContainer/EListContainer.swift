import UIKit

public final class EListContainer: UIView, EComponent {
    public private(set) var viewModel: ViewModel = ViewModel()

    private static let cellReuseIdentifier = "EListContainerCell"

    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.register(ECollectionCell.self, forCellWithReuseIdentifier: Self.cellReuseIdentifier)
        return cv
    }()

    private var items: [ComponentDescriptor] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        collectionView.isPagingEnabled = viewModel.isPagingEnabled
        if axisChanged || spacingChanged {
            collectionView.setCollectionViewLayout(makeLayout(), animated: false)
        }
        return self
    }

    public func setItems(_ items: [ComponentDescriptor]) {
        self.items = items
        collectionView.reloadData()
    }

    // MARK: - Private

    private func setupCollectionView() {
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self else { return nil }
            let itemSize = NSCollectionLayoutSize(
                widthDimension: self.viewModel.axis == .vertical ? .fractionalWidth(1.0) : .estimated(100),
                heightDimension: self.viewModel.axis == .vertical ? .estimated(44) : .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: self.viewModel.axis == .vertical ? .fractionalWidth(1.0) : .estimated(100),
                heightDimension: self.viewModel.axis == .vertical ? .estimated(44) : .fractionalHeight(1.0)
            )
            let group: NSCollectionLayoutGroup
            if self.viewModel.axis == .vertical {
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            }

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = self.viewModel.spacing

            if self.viewModel.axis == .horizontal {
                section.orthogonalScrollingBehavior = self.viewModel.isPagingEnabled ? .paging : .continuous
            }

            return section
        }
    }
}

// MARK: - UICollectionViewDataSource

extension EListContainer: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Self.cellReuseIdentifier,
            for: indexPath
        )
        if let eCell = cell as? ECollectionCell {
            eCell.configure(with: items[indexPath.item])
        }
        return cell
    }
}
