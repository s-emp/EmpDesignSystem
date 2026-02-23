import UIKit

public extension EmpInfoCard {
    enum Preset {
        public static func `default`(
            subtitle: String,
            value: String
        ) -> ViewModel {
            ViewModel(
                common: CommonViewModel(
                    corners: .init(radius: 12),
                    layoutMargins: UIEdgeInsets(
                        top: EmpSpacing.m.rawValue,
                        left: EmpSpacing.m.rawValue,
                        bottom: EmpSpacing.m.rawValue,
                        right: EmpSpacing.m.rawValue
                    )
                ),
                subtitle: subtitle,
                value: value
            )
        }

        public static func gradient(
            subtitle: String,
            value: String,
            gradient: EmpGradient
        ) -> ViewModel {
            ViewModel(
                common: CommonViewModel(
                    corners: .init(radius: 12),
                    layoutMargins: UIEdgeInsets(
                        top: EmpSpacing.m.rawValue,
                        left: EmpSpacing.m.rawValue,
                        bottom: EmpSpacing.m.rawValue,
                        right: EmpSpacing.m.rawValue
                    )
                ),
                subtitle: subtitle,
                value: value,
                subtitleColor: .white.withAlphaComponent(0.7),
                valueColor: .white,
                background: .gradient(gradient)
            )
        }
    }
}
