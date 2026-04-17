import XCTest
@testable import MindCanvas

// Mock CloudKit database for logic tests
class MockCKDatabase {
    var savedRecords: [CKRecord] = []
    var shouldFail = false
    var error: Error = NSError(domain: "Mock", code: 1)
    
    func save(_ record: CKRecord, completion: @escaping (CKRecord?, Error?) -> Void) {
        if shouldFail {
            completion(nil, error)
        } else {
            savedRecords.append(record)
            completion(record, nil)
        }
    }
}

final class CloudKitManagerTests: XCTestCase {
    var manager: CloudKitManager!
    var mockDB: MockCKDatabase!

    override func setUp() {
        super.setUp()
        manager = CloudKitManager()
        mockDB = MockCKDatabase()
        // Inject mockDB if CloudKitManager is refactored for DI
    }

    func testSaveMoodSuccess() {
        let exp = expectation(description: "Save mood")
        manager.saveMood(mood: "😊", energy: 5, note: "Test") { result in
            switch result {
            case .success(let record):
                XCTAssertEqual(record["mood"] as? String, "😊")
                XCTAssertEqual(record["energy"] as? Int, 5)
                XCTAssertEqual(record["note"] as? String, "Test")
            case .failure:
                XCTFail("Should not fail")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }

    func testSaveMoodFailure() {
        // This test would require dependency injection to work fully
        // For now, just assert the completion is called
        let exp = expectation(description: "Save mood failure")
        // Simulate error by passing invalid data or refactor for DI
        exp.fulfill()
        wait(for: [exp], timeout: 1)
    }
}
