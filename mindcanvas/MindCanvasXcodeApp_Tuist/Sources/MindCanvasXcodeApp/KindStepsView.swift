import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct KindStepsView: View {
    let steps = [
        "Hydration",
        "Breathing",
        "Gratitude",
        "Stretching",
        "Affirmation"
    ]
    @available(iOS 15.0, macOS 10.15, *)
    var body: some View {
        List(steps, id: \.self) { step in
            HStack {
                if #available(macOS 11.0, *) {
                    Image(systemName: "checkmark.circle")
                }
                Text(step)
            }
        }
        .modifier(NavigationTitleModifier())
    }

struct NavigationTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(macOS 11.0, *) {
            content.navigationTitle("Kind Steps")
        } else {
            content
        }
    }
}
}

#if DEBUG
@available(iOS 15.0, macOS 10.15, *)
struct KindStepsView_Previews: PreviewProvider {
    @available(iOS 15.0, macOS 10.15, *)
    static var previews: some View {
        KindStepsView()
    }
}
#endif