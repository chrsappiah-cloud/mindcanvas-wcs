// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "MindCanvasXcodeApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(name: "MindCanvasXcodeApp", targets: ["MindCanvasXcodeApp"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MindCanvasXcodeApp",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("../Resources/Info.plist"),
                .process("../Resources/LaunchScreen.storyboard")
            ]
        )
    ]
)
