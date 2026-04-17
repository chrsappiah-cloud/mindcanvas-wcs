import Foundation
import CloudKit
import Combine


@available(iOS 15.0, macOS 10.15, *)
class CloudKitManager: ObservableObject {
    let container: CKContainer
    let database: CKDatabase
    @Published var moods: [CKRecord] = []
    @Published var memories: [CKRecord] = []
    @Published var creativeEntries: [CKRecord] = []

    // Dependency injection for testability
    init(container: CKContainer = CKContainer.default(), database: CKDatabase? = nil) {
        self.container = container
        self.database = database ?? container.publicCloudDatabase
    }

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

    func saveMemory(title: String, tags: String, note: String, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Memory")
        record["title"] = title as CKRecordValue
        record["tags"] = tags as CKRecordValue
        record["note"] = note as CKRecordValue
        database.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let savedRecord = savedRecord {
                    self.memories.append(savedRecord)
                    completion(.success(savedRecord))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchMemories(completion: ((Result<[CKRecord], Error>) -> Void)? = nil) {
        let query = CKQuery(recordType: "Memory", predicate: NSPredicate(value: true))
        if #available(macOS 12.0, iOS 15.0, *) {
            database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
                switch result {
                case .success(let (matchedResults, _)):
                    let records = matchedResults.compactMap { result in
                        do {
                            return try result.1.get()
                        } catch {
                            return nil
                        }
                    }
                    DispatchQueue.main.async {
                        self.memories = records
                        completion?(.success(records))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion?(.failure(error))
                    }
                }
            }
        } else {
            database.perform(query, inZoneWith: nil) { records, error in
                DispatchQueue.main.async {
                    if let records = records {
                        self.memories = records
                        completion?(.success(records))
                    } else if let error = error {
                        completion?(.failure(error))
                    }
                }
            }
        }
    }

    func saveCreativeEntry(color: String, brushSize: Double, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "CreativeEntry")
        record["color"] = color as CKRecordValue
        record["brushSize"] = brushSize as CKRecordValue
        record["timestamp"] = Date() as CKRecordValue
        database.save(record) { savedRecord, error in
            DispatchQueue.main.async {
                if let savedRecord = savedRecord {
                    self.creativeEntries.append(savedRecord)
                    completion(.success(savedRecord))
                } else if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchCreativeEntries(completion: ((Result<[CKRecord], Error>) -> Void)? = nil) {
        let query = CKQuery(recordType: "CreativeEntry", predicate: NSPredicate(value: true))
        if #available(macOS 12.0, iOS 15.0, *) {
            database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
                switch result {
                case .success(let (matchedResults, _)):
                    let records = matchedResults.compactMap { result in
                        do {
                            return try result.1.get()
                        } catch {
                            return nil
                        }
                    }
                    DispatchQueue.main.async {
                        self.creativeEntries = records
                        completion?(.success(records))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion?(.failure(error))
                    }
                }
            }
        } else {
            database.perform(query, inZoneWith: nil) { records, error in
                DispatchQueue.main.async {
                    if let records = records {
                        self.creativeEntries = records
                        completion?(.success(records))
                    } else if let error = error {
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    func fetchMoods() {
        let query = CKQuery(recordType: "MoodEntry", predicate: NSPredicate(value: true))
        if #available(macOS 12.0, iOS 15.0, *) {
            database.fetch(withQuery: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: CKQueryOperation.maximumResults) { result in
                switch result {
                case .success(let (matchedResults, _)):
                    let records = matchedResults.compactMap { result in
                        do {
                            return try result.1.get()
                        } catch {
                            return nil
                        }
                    }
                    DispatchQueue.main.async {
                        self.moods = records
                    }
                case .failure(_):
                    break
                }
            }
        } else {
            database.perform(query, inZoneWith: nil) { records, error in
                DispatchQueue.main.async {
                    if let records = records {
                        self.moods = records
                    }
                }
            }
        }
    }
}
