import XCTest
@testable import MindCanvas

@available(iOS 15.0, macOS 10.15, *)
final class MemoryViewModelTests: XCTestCase {
    func testMemoryCreationSavesMemory() {
        let mockDB = MockCKDatabase()
        let manager = CloudKitManager(database: mockDB as! CKDatabase) // For test, cast or adapt as needed
        let viewModel = MemoryViewModel(cloudKitManager: manager)
        viewModel.title = "A day at the park"
        viewModel.tags = "outdoors,fun"
        viewModel.note = "Sunny and joyful"
        let exp = expectation(description: "Save memory")
        viewModel.saveMemory { result in
            switch result {
            case .success(let record):
                XCTAssertEqual(record["title"] as? String, "A day at the park")
                XCTAssertEqual(record["tags"] as? String, "outdoors,fun")
                XCTAssertEqual(record["note"] as? String, "Sunny and joyful")
            case .failure:
                XCTFail("Should not fail")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
