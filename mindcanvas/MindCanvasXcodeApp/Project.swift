import ProjectDescription

let project = Project(
    name: "MindCanvasXcodeApp",
    organizationName: "World Class Scholars",
    targets: [
        Target(
            name: "MindCanvasXcodeApp",
            platform: .iOS,
            product: .app,
            bundleId: "com.worldclassscholars.mindcanvas",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: ["iphone", "ipad"]),
            infoPlist: .infoPlist(path: "Resources/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
