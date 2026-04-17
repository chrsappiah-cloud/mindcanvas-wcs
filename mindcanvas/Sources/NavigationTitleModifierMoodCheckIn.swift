import SwiftUI

@available(iOS 13.0, macOS 10.15, *)
struct NavigationTitleModifierMoodCheckIn: ViewModifier {
    @available(iOS 13.0, macOS 10.15, *)
    func body(content: Content) -> some View {
        if #available(macOS 11.0, *) {
            content.navigationTitle("Mood Check-In")
        } else {
            content
        }
    }
}
