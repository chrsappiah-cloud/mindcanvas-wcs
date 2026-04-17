import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct OnboardingView: View {
    @State private var step = 0
    var onFinish: () -> Void
    let steps = [
        ("Welcome to MindCanvas!", "Your space for moods, memories, and creativity."),
        ("Mood Check-In", "Track how you feel and reflect daily."),
        ("Memory Cards", "Save special moments and revisit them anytime."),
        ("Creative Studio", "Express yourself with colors and creativity."),
        ("Get Started!", "Ready to explore? Tap below to begin.")
    ]
    @available(iOS 15.0, macOS 10.15, *)
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text(steps[step].0)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
            if #available(macOS 11.0, *) {
                Text(steps[step].1)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            } else {
                Text(steps[step].1)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                if step < steps.count - 1 {
                    step += 1
                } else {
                    onFinish()
                }
            }) {
                Text(step < steps.count - 1 ? "Next" : "Start")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}