import XCTest
@testable import MindCanvas

@available(iOS 15.0, macOS 10.15, *)
final class OnboardingViewModelTests: XCTestCase {
    func testOnboardingStartsAtWelcome() {
        let vm = OnboardingViewModel()
        XCTAssertEqual(vm.currentStep, .welcome)
    }
    func testOnboardingNextStep() {
        let vm = OnboardingViewModel()
        vm.nextStep()
        XCTAssertEqual(vm.currentStep, .permissions)
        vm.nextStep()
        XCTAssertEqual(vm.currentStep, .complete)
    }
    func testOnboardingReset() {
        let vm = OnboardingViewModel()
        vm.nextStep()
        vm.reset()
        XCTAssertEqual(vm.currentStep, .welcome)
    }
}
