// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MindCanvas",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MindCanvas",
            targets: ["MindCanvas"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MindCanvas",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "MindCanvasTests",
            dependencies: ["MindCanvas"],
            path: "Tests"
        ),
    ]
)
