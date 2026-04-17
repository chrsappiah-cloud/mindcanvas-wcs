import SwiftUI
import CloudKit

@available(iOS 15.0, macOS 11.0, *)
public struct MindCanvasApp: App {
    @StateObject private var cloudKitManager = CloudKitManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    public init() {}
    public var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                HomeDashboardView()
                    .environmentObject(cloudKitManager)
            } else {
                OnboardingView {
                    hasSeenOnboarding = true
                }
                .environmentObject(cloudKitManager)
            }
        }
    }
}