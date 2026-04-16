import SwiftUI

struct KindStepsView: View {
    let steps = [
        "Hydration",
        "Breathing",
        "Gratitude",
        "Stretching",
        "Affirmation"
    ]
    var body: some View {
        List(steps, id: \.self) { step in
            HStack {
                Image(systemName: "checkmark.circle")
                Text(step)
            }
        }
        .navigationTitle("Kind Steps")
    }
}

#Preview {
    KindStepsView()
}
