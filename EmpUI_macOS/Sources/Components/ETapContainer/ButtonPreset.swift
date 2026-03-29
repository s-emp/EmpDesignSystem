import AppKit

public extension ComponentDescriptor {

    enum ButtonPreset {
        public enum ColorVariant { case primary, danger }
        public enum Size { case small, medium, large }

        public static func filled(
            _ color: ColorVariant,
            title: String,
            icon: NSImage? = nil,
            size: Size = .medium,
            action: ETapContainer.ViewModel.Action
        ) -> ComponentDescriptor {
            let s = SizeConfig(for: size)
            let colors = filledColors(for: color)

            func content(bg: NSColor, contentAlpha: CGFloat) -> ComponentDescriptor {
                .stack(.init(
                    common: .init(
                        corners: .init(radius: s.cornerRadius),
                        backgroundColor: bg,
                        layoutMargins: s.margins
                    ),
                    orientation: .horizontal,
                    spacing: s.spacing,
                    alignment: .centerY
                ), [
                    icon.map { .image(.init(
                        image: $0,
                        tintColor: colors.content.withAlphaComponent(contentAlpha),
                        size: CGSize(width: s.iconSize, height: s.iconSize)
                    )) },
                    .text(.init(content: .plain(.init(
                        text: title,
                        font: s.font,
                        color: colors.content.withAlphaComponent(contentAlpha)
                    )))),
                ].compactMap { $0 })
            }

            return .tap(
                .init(action: action),
                ControlParameter(
                    normal: content(bg: colors.background, contentAlpha: 1.0),
                    highlighted: content(bg: colors.backgroundPressed, contentAlpha: 0.7),
                    disabled: content(bg: colors.background.withAlphaComponent(0.38), contentAlpha: 0.38)
                )
            )
        }

        // MARK: - Colors

        private struct ColorSet {
            let background: NSColor
            let backgroundPressed: NSColor
            let content: NSColor
        }

        private static func filledColors(for variant: ColorVariant) -> ColorSet {
            switch variant {
            case .primary:
                return ColorSet(
                    background: .Semantic.actionPrimary,
                    backgroundPressed: .Semantic.actionPrimaryHover,
                    content: .Semantic.textPrimaryInverted
                )
            case .danger:
                return ColorSet(
                    background: .Semantic.actionDanger,
                    backgroundPressed: .Semantic.actionDangerHover,
                    content: .Semantic.textPrimaryInverted
                )
            }
        }

        // MARK: - Size Config

        private struct SizeConfig {
            let height: CGFloat
            let font: NSFont
            let iconSize: CGFloat
            let cornerRadius: CGFloat
            let spacing: CGFloat
            let margins: NSEdgeInsets

            init(for size: Size) {
                switch size {
                case .small:
                    height = 36
                    font = .systemFont(ofSize: 12, weight: .medium)
                    iconSize = 16
                    cornerRadius = 6
                    spacing = EmpSpacing.xxs.rawValue
                    margins = NSEdgeInsets(top: .xs, left: .s, bottom: .xs, right: .s)
                case .medium:
                    height = 44
                    font = .systemFont(ofSize: 14, weight: .medium)
                    iconSize = 20
                    cornerRadius = 8
                    spacing = EmpSpacing.xs.rawValue
                    margins = NSEdgeInsets(top: .s, left: .m, bottom: .s, right: .m)
                case .large:
                    height = 50
                    font = .systemFont(ofSize: 16, weight: .medium)
                    iconSize = 24
                    cornerRadius = 10
                    spacing = EmpSpacing.s.rawValue
                    margins = NSEdgeInsets(top: .m, left: .l, bottom: .m, right: .l)
                }
            }
        }
    }
}
