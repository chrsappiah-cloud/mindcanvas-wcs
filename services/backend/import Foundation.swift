import Foundation
import CloudKit
import Combine

class CloudKitManager: ObservableObject {
    let container = CKContainer.default()
    let database = CKContainer.default().publicCloudDatabase

    @Published var moods: [CKRecord] = []

    func saveMood(mood: String, energy: Int, note: String, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "MoodEntry")
        record["mood"] = mood as CKRecordValue
        record["energy"] = energy as CKRecordValue
        record["note"] = note as CKRecordValue
        database.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let savedRecord = savedRecord {
                    self.moods.append(savedRecord)
                    completion(.success(savedRecord))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchMoods() {
        let query = CKQuery(recordType: "MoodEntry", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { records, error in
            DispatchQueue.main.async {
                if let records = records {
                    self.moods = records
                }
            }
        }
    }
}