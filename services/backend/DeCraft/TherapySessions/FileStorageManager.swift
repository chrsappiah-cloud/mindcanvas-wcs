import Foundation

class FileStorageManager {
    static let shared = FileStorageManager()
    private let fileManager = FileManager.default
    
    // Local Documents directory
    var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // iCloud Documents directory (if available)
    var iCloudDirectory: URL? {
        fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }
    
    // Save data locally
    func saveLocal(data: Data, fileName: String) throws {
        let url = documentsDirectory.appendingPathComponent(fileName)
        try data.write(to: url)
    }
    
    // Load data locally
    func loadLocal(fileName: String) -> Data? {
        let url = documentsDirectory.appendingPathComponent(fileName)
        return try? Data(contentsOf: url)
    }
    
    // Save data to iCloud
    func saveToiCloud(data: Data, fileName: String) throws {
        guard let iCloudURL = iCloudDirectory else { throw NSError(domain: "iCloud unavailable", code: 1) }
        let url = iCloudURL.appendingPathComponent(fileName)
        try fileManager.createDirectory(at: iCloudURL, withIntermediateDirectories: true)
        try data.write(to: url)
    }
    
    // Load data from iCloud
    func loadFromiCloud(fileName: String) -> Data? {
        guard let iCloudURL = iCloudDirectory else { return nil }
        let url = iCloudURL.appendingPathComponent(fileName)
        return try? Data(contentsOf: url)
    }
}
