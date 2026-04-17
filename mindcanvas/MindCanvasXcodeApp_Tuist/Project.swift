import ProjectDescription

let project = Project(
    name: "MindCanvasXcodeApp",
    targets: [
        .target(
            name: "MindCanvasXcodeApp",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.MindCanvasXcodeApp",
            infoPlist: "Resources/MindCanvasXcodeApp/Info.plist",
            sources: ["Sources/MindCanvasXcodeApp/*.swift"],
            resources: ["Resources/MindCanvasXcodeApp/LaunchScreen.storyboard"],
            dependencies: []
        ),
        .target(
            name: "MindCanvasXcodeAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.MindCanvasXcodeAppTests",
            infoPlist: .default,
            buildableFolders: [
                "MindCanvasXcodeApp/Tests"
            ],
            dependencies: [.target(name: "MindCanvasXcodeApp")]
        ),
    ]
)
