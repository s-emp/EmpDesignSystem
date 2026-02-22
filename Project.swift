import ProjectDescription

let project = Project(
    name: "EmpDesignSystem",
    targets: [
        .target(
            name: "EmpDesignSystem",
            destinations: .macOS,
            product: .app,
            bundleId: "dev.tuist.EmpDesignSystem",
            infoPlist: .default,
            buildableFolders: [
                "EmpDesignSystem/Sources",
                "EmpDesignSystem/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "EmpDesignSystemTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "dev.tuist.EmpDesignSystemTests",
            infoPlist: .default,
            buildableFolders: [
                "EmpDesignSystem/Tests"
            ],
            dependencies: [.target(name: "EmpDesignSystem")]
        ),
    ]
)
