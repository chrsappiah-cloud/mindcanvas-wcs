import Foundation
import CloudKit
import Combine

@available(iOS 15.0, macOS 10.15, *)
class CloudKitManager: ObservableObject {
    // Update this identifier to match your valid CloudKit container
    let container = CKContainer(identifier: "icloud.mindcanvas")
    let database: CKDatabase

    init() {
        self.database = container.publicCloudDatabase
    }
    @Published var moods: [CKRecord] = []
    @Published var memories: [CKRecord] = []
    @Published var creativeEntries: [CKRecord] = []
    
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
        var fetchedRecords: [CKRecord] = []
        let operation = CKQueryOperation(query: query)
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { recordID, result in
                switch result {
                case .success(let record):
                    fetchedRecords.append(record)
                case .failure(_):
                    break // handle error if needed
                }
            }
            operation.queryResultBlock = { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.memories = fetchedRecords
                        completion?(.success(fetchedRecords))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                }
            }
        } else {
            operation.recordFetchedBlock = { record in
                fetchedRecords.append(record)
            }
            operation.queryCompletionBlock = { cursor, error in
                DispatchQueue.main.async {
                    if error == nil {
                        self.memories = fetchedRecords
                        completion?(.success(fetchedRecords))
                    } else if let error = error {
                        completion?(.failure(error))
                    }
                }
            }
        }
        database.add(operation)
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
        var fetchedRecords: [CKRecord] = []
        let operation = CKQueryOperation(query: query)
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { recordID, result in
                switch result {
                case .success(let record):
                    fetchedRecords.append(record)
                case .failure(_):
                    break // handle error if needed
                }
            }
            operation.queryResultBlock = { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.creativeEntries = fetchedRecords
                        completion?(.success(fetchedRecords))
                    case .failure(let error):
                        completion?(.failure(error))
                    }
                }
            }
        } else {
            operation.recordFetchedBlock = { record in
                fetchedRecords.append(record)
            }
            operation.queryCompletionBlock = { cursor, error in
                DispatchQueue.main.async {
                    if error == nil {
                        self.creativeEntries = fetchedRecords
                        completion?(.success(fetchedRecords))
                    } else if let error = error {
                        completion?(.failure(error))
                    }
                }
            }
        }
        database.add(operation)
    }
    
    func fetchMoods() {
        let query = CKQuery(recordType: "MoodEntry", predicate: NSPredicate(value: true))
        var fetchedRecords: [CKRecord] = []
        let operation = CKQueryOperation(query: query)
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { recordID, result in
                switch result {
                case .success(let record):
                    fetchedRecords.append(record)
                case .failure(_):
                    break // handle error if needed
                }
            }
            operation.queryResultBlock = { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        self.moods = fetchedRecords
                    case .failure(_):
                        break
                    }
                }
            }
        } else {
            operation.recordFetchedBlock = { record in
                fetchedRecords.append(record)
            }
            operation.queryCompletionBlock = { cursor, error in
                DispatchQueue.main.async {
                    if error == nil {
                        self.moods = fetchedRecords
                    }
                }
            }
        }
        database.add(operation)
    }
}