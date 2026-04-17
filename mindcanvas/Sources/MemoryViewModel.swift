import Foundation
import Combine
import CloudKit

@available(iOS 15.0, macOS 10.15, *)
final class MemoryViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var tags: String = ""
    @Published var note: String = ""
    var cloudKitManager: CloudKitManager
    
    init(cloudKitManager: CloudKitManager) {
        self.cloudKitManager = cloudKitManager
    }
    
    func saveMemory(completion: @escaping (Result<CKRecord, Error>) -> Void) {
        cloudKitManager.saveMemory(title: title, tags: tags, note: note, completion: completion)
    }
}
