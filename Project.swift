import ProjectDescription

let project = Project(
    name: "EmpDesignSystem",
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
