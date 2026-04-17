// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MindCanvasApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(
            name: "MindCanvasApp",
            targets: ["MindCanvasApp"]),
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "MindCanvasApp",
            dependencies: ["MindCanvas"],
            path: "."
        )
    ]
)
