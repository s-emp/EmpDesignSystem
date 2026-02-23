import ProjectDescription

let project = Project(
    name: "EmpDesignSystem",
    settings: .settings(base: ["SWIFT_VERSION": "6"]),
    targets: [
        // MARK: - Frameworks

        .target(
            name: "EmpUI_iOS",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.emp.EmpUI-iOS",
            sources: ["EmpUI_iOS/Sources/**"],
            dependencies: []
        ),
        .target(
            name: "EmpUI_macOS",
            destinations: .macOS,
            product: .framework,
            bundleId: "dev.emp.EmpUI-macOS",
            sources: ["EmpUI_macOS/Sources/**"],
            dependencies: []
        ),

        // MARK: - Sandbox App

        .target(
            name: "EmpDesignSystem",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.emp.EmpDesignSystem",
            infoPlist: .default,
            sources: ["EmpDesignSystem/Sources/**"],
            resources: ["EmpDesignSystem/Resources/**"],
            dependencies: [
                .target(name: "EmpUI_macOS"),
            ]
        ),

        // MARK: - Tests

        .target(
            name: "EmpUI_iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.emp.EmpUI-iOSTests",
            sources: ["EmpUI_iOS/Tests/**"],
            dependencies: [
                .target(name: "EmpUI_iOS"),
                .external(name: "SnapshotTesting"),
            ]
        ),
        .target(
            name: "EmpUI_macOSTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.emp.EmpUI-macOSTests",
            sources: ["EmpUI_macOS/Tests/**"],
            dependencies: [
                .target(name: "EmpUI_macOS"),
                .external(name: "SnapshotTesting"),
            ]
        ),
        .target(
            name: "EmpDesignSystemTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.emp.EmpDesignSystemTests",
            sources: ["EmpDesignSystem/Tests/**"],
            dependencies: [
                .target(name: "EmpDesignSystem"),
            ]
        ),
    ]
)
