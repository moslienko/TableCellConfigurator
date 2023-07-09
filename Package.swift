// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TableCellConfigurator",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "TableCellConfigіurator",
            targets: ["TableCellConfigurator"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/moslienko/AppViewUtilits.git", from: "1.2.5")
    ],
    targets: [
        .target(
            name: "TableCellConfigurator",
            dependencies: [
                .package(url: "https://github.com/moslienko/AppViewUtilits.git", from: "1.2.5")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "TableCellConfiguratorTests",
            dependencies: ["TableCellConfigurator"],
            path: "Tests"
        ),
    ]
)
