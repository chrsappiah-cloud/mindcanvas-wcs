import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct OnboardingView: View {
    @State private var step = 0
    var onFinish: () -> Void
    let steps = [
        (NSLocalizedString("Welcome to MindCanvas!", comment: "onboarding title"), NSLocalizedString("Your space for moods, memories, and creativity.", comment: "onboarding desc")),
        (NSLocalizedString("Mood Check-In", comment: "onboarding title"), NSLocalizedString("Track how you feel and reflect daily.", comment: "onboarding desc")),
        (NSLocalizedString("Memory Cards", comment: "onboarding title"), NSLocalizedString("Save special moments and revisit them anytime.", comment: "onboarding desc")),
        (NSLocalizedString("Creative Studio", comment: "onboarding title"), NSLocalizedString("Express yourself with colors and creativity.", comment: "onboarding desc")),
        (NSLocalizedString("Get Started!", comment: "onboarding title"), NSLocalizedString("Ready to explore? Tap below to begin.", comment: "onboarding desc"))
    ]
    @available(iOS 15.0, macOS 10.15, *)
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text(steps[step].0)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            if #available(macOS 11.0, *) {
                Text(steps[step].1)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(steps[step].1)
            } else {
                Text(steps[step].1)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .accessibilityLabel(steps[step].1)
            }
            Spacer()
            Button(action: {
                if step < steps.count - 1 {
                    step += 1
                    UIAccessibility.post(notification: .announcement, argument: "Step advanced")
                } else {
                    onFinish()
                    UIAccessibility.post(notification: .announcement, argument: "Onboarding complete. Welcome!")
                }
            }) {
                Text(step < steps.count - 1 ? "Next" : "Start")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .accessibilityLabel(step < steps.count - 1 ? "Next step" : "Start app")
            .accessibilityHint("Advances onboarding or starts the app.")
            .padding(.horizontal)
        }
        .padding()
    }
}
