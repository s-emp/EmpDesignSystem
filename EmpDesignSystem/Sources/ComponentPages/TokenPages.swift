import Cocoa
import EmpUI_macOS

@MainActor
enum TokenPages {

    private static let tokenItemIds: Set<String> = [
        "typography", "colors", "spacing", "opacity",
        "shape-presets", "shadow-presets",
    ]

    static func isTokenPage(_ itemId: String) -> Bool {
        tokenItemIds.contains(itemId)
    }

    static func makePage(for itemId: String) -> NSView? {
        switch itemId {
        case "typography": return typography()
        case "colors": return colors()
        case "spacing": return spacing()
        case "opacity": return opacity()
        case "shape-presets", "shadow-presets": return comingSoon(itemId)
        default: return nil
        }
    }

    // MARK: - Typography

    static func typography() -> NSView {
        let allStyles: [(name: String, style: EmpTypography)] = [
            ("largeTitle", .largeTitle),
            ("title1", .title1),
            ("title2", .title2),
            ("title3", .title3),
            ("headline", .headline),
            ("body", .body),
            ("callout", .callout),
            ("subheadline", .subheadline),
            ("footnote", .footnote),
            ("caption1", .caption1),
            ("caption2", .caption2),
        ]

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)),
            orientation: .vertical,
            spacing: 16,
            alignment: .leading
        ))

        for (name, style) in allStyles {
            let row = EStack()
            let _ = row.configure(with: .init(
                orientation: .vertical,
                spacing: 4,
                alignment: .leading
            ))

            let sample = EText()
            let _ = sample.configure(with: .init(
                content: .plain(.init(
                    text: "The quick brown fox jumps over the lazy dog",
                    font: style.font,
                    color: .Semantic.textPrimary
                ))
            ))

            let meta = EText()
            let _ = meta.configure(with: .init(
                content: .plain(.init(
                    text: "\(name) \u{2014} \(Int(style.fontSize))pt / \(Int(style.lineHeight))pt line height",
                    font: .systemFont(ofSize: 11),
                    color: .Semantic.textSecondary
                ))
            ))

            row.addArrangedSubview(sample)
            row.addArrangedSubview(meta)
            stack.addArrangedSubview(row)
        }

        return wrapInScroll(stack)
    }

    // MARK: - Colors

    static func colors() -> NSView {
        let allColors: [(name: String, color: NSColor)] = [
            // Backgrounds
            ("backgroundPrimary", .Semantic.backgroundPrimary),
            ("backgroundSecondary", .Semantic.backgroundSecondary),
            ("backgroundTertiary", .Semantic.backgroundTertiary),
            // Text
            ("textPrimary", .Semantic.textPrimary),
            ("textSecondary", .Semantic.textSecondary),
            ("textTertiary", .Semantic.textTertiary),
            ("textAccent", .Semantic.textAccent),
            // Borders
            ("borderDefault", .Semantic.borderDefault),
            ("borderSubtle", .Semantic.borderSubtle),
            // Actions
            ("actionPrimary", .Semantic.actionPrimary),
            ("actionSuccess", .Semantic.actionSuccess),
            ("actionWarning", .Semantic.actionWarning),
            ("actionDanger", .Semantic.actionDanger),
            ("actionInfo", .Semantic.actionInfo),
            // Cards
            ("cardLavender", .Semantic.cardLavender),
            ("cardMint", .Semantic.cardMint),
            ("cardPeach", .Semantic.cardPeach),
            ("cardRose", .Semantic.cardRose),
            ("cardSky", .Semantic.cardSky),
            ("cardLemon", .Semantic.cardLemon),
            ("cardLilac", .Semantic.cardLilac),
        ]

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)),
            orientation: .vertical,
            spacing: 8,
            alignment: .leading
        ))

        for (name, color) in allColors {
            let row = EStack()
            let _ = row.configure(with: .init(
                orientation: .horizontal,
                spacing: 12,
                alignment: .centerY
            ))

            let swatch = EStack()
            let _ = swatch.configure(with: .init(
                common: .init(
                    border: .init(width: 1, color: .Semantic.borderSubtle),
                    corners: .init(radius: 4),
                    backgroundColor: color
                )
            ))
            swatch.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                swatch.widthAnchor.constraint(equalToConstant: 32),
                swatch.heightAnchor.constraint(equalToConstant: 32),
            ])

            let label = EText()
            let _ = label.configure(with: .init(
                content: .plain(.init(
                    text: "Semantic.\(name)",
                    font: .systemFont(ofSize: 13),
                    color: .Semantic.textPrimary
                ))
            ))

            row.addArrangedSubview(swatch)
            row.addArrangedSubview(label)
            stack.addArrangedSubview(row)
        }

        return wrapInScroll(stack)
    }

    // MARK: - Spacing

    static func spacing() -> NSView {
        let allSpacings: [(name: String, value: EmpSpacing)] = [
            ("xxs", .xxs),
            ("xs", .xs),
            ("s", .s),
            ("m", .m),
            ("l", .l),
            ("xl", .xl),
            ("xxl", .xxl),
            ("xxxl", .xxxl),
        ]

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)),
            orientation: .vertical,
            spacing: 12,
            alignment: .leading
        ))

        for (name, spacing) in allSpacings {
            let row = EStack()
            let _ = row.configure(with: .init(
                orientation: .horizontal,
                spacing: 12,
                alignment: .centerY
            ))

            let bar = EStack()
            let _ = bar.configure(with: .init(
                common: .init(
                    corners: .init(radius: 3),
                    backgroundColor: .Semantic.actionPrimary
                )
            ))
            bar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bar.widthAnchor.constraint(equalToConstant: spacing.rawValue),
                bar.heightAnchor.constraint(equalToConstant: 24),
            ])

            let label = EText()
            let _ = label.configure(with: .init(
                content: .plain(.init(
                    text: "\(name) \u{2014} \(Int(spacing.rawValue))pt",
                    font: .systemFont(ofSize: 13),
                    color: .Semantic.textPrimary
                ))
            ))

            row.addArrangedSubview(bar)
            row.addArrangedSubview(label)
            stack.addArrangedSubview(row)
        }

        return wrapInScroll(stack)
    }

    // MARK: - Opacity

    static func opacity() -> NSView {
        let allOpacities: [(name: String, value: EmpOpacity)] = [
            ("full", .full),
            ("high", .high),
            ("medium", .medium),
            ("muted", .muted),
            ("disabled", .disabled),
            ("faint", .faint),
            ("none", .none),
        ]

        let stack = EStack()
        let _ = stack.configure(with: .init(
            common: .init(layoutMargins: NSEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)),
            orientation: .vertical,
            spacing: 8,
            alignment: .leading
        ))

        for (name, opacity) in allOpacities {
            let row = EStack()
            let _ = row.configure(with: .init(
                orientation: .horizontal,
                spacing: 12,
                alignment: .centerY
            ))

            let swatch = EStack()
            let _ = swatch.configure(with: .init(
                common: .init(
                    border: .init(width: 1, color: .Semantic.borderSubtle),
                    corners: .init(radius: 4),
                    backgroundColor: NSColor.Semantic.actionPrimary.withAlphaComponent(opacity.rawValue)
                )
            ))
            swatch.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                swatch.widthAnchor.constraint(equalToConstant: 32),
                swatch.heightAnchor.constraint(equalToConstant: 32),
            ])

            let label = EText()
            let _ = label.configure(with: .init(
                content: .plain(.init(
                    text: "\(name) \u{2014} \(opacity.rawValue)",
                    font: .systemFont(ofSize: 13),
                    color: .Semantic.textPrimary
                ))
            ))

            row.addArrangedSubview(swatch)
            row.addArrangedSubview(label)
            stack.addArrangedSubview(row)
        }

        return wrapInScroll(stack)
    }

    // MARK: - Coming Soon

    private static func comingSoon(_ itemId: String) -> NSView {
        let label = EText()
        let _ = label.configure(with: .init(
            content: .plain(.init(
                text: "\(itemId) \u{2014} coming soon",
                font: .systemFont(ofSize: 14),
                color: .Semantic.textTertiary
            )),
            alignment: .center
        ))
        return label
    }

    // MARK: - Helpers

    private static func wrapInScroll(_ content: NSView) -> NSView {
        let scroll = EScroll()
        let _ = scroll.configure(with: .init(
            orientation: .vertical,
            showsIndicators: true
        ))
        scroll.documentView = content
        content.translatesAutoresizingMaskIntoConstraints = false

        let clipView = scroll.contentView
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: clipView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: clipView.trailingAnchor),
        ])

        return scroll
    }
}
