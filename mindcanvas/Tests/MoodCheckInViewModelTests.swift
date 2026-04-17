import XCTest
@testable import MindCanvas

@available(iOS 15.0, macOS 10.15, *)
final class MoodCheckInViewModel {
    @Published var mood: String = "😊"
    @Published var energy: Double = 5
    @Published var note: String = ""
    var cloudKitManager: CloudKitManager
    
    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
    
    func saveMood(completion: @escaping (Result<CKRecord, Error>) -> Void) {
        cloudKitManager.saveMood(mood: mood, energy: Int(energy), note: note, completion: completion)
    }
}

@available(iOS 15.0, macOS 10.15, *)
final class MoodCheckInFlowTests: XCTestCase {
    func testMoodCheckInSavesMood() {
        let mockDB = MockCKDatabase()
        let manager = CloudKitManager(database: mockDB as! CKDatabase) // For test, cast or adapt as needed
        let viewModel = MoodCheckInViewModel(cloudKitManager: manager)
        viewModel.mood = "😐"
        viewModel.energy = 7
        viewModel.note = "Feeling okay"
        let exp = expectation(description: "Save mood")
        viewModel.saveMood { result in
            switch result {
            case .success(let record):
                XCTAssertEqual(record["mood"] as? String, "😐")
                XCTAssertEqual(record["energy"] as? Int, 7)
                XCTAssertEqual(record["note"] as? String, "Feeling okay")
            case .failure:
                XCTFail("Should not fail")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
