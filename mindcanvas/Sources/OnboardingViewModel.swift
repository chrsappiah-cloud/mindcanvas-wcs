import Foundation
import Combine
import CloudKit

@available(iOS 15.0, macOS 10.15, *)
final class OnboardingViewModel: ObservableObject {
    enum Step: String, CaseIterable {
        case welcome, permissions, complete
    }
    @Published var currentStep: Step = .welcome
    func nextStep() {
        if let idx = Step.allCases.firstIndex(of: currentStep), idx + 1 < Step.allCases.count {
            currentStep = Step.allCases[idx + 1]
        }
    }
    func reset() {
        currentStep = .welcome
    }
}
