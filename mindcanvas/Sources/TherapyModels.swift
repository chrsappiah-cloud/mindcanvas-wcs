import SwiftData
import HealthKit

@Model
class TherapySession {
    var id: UUID = UUID()
    var date: Date = Date()
    var mood: String = "neutral"  // From StateOfMind
    var duration: TimeInterval = 0
    var drawings: [Data]?  // PKDrawing export
    var mediaFiles: [String] = []  // Local URLs
}

@Model
class PatientProfile {
    var name: String
    var mediaLibrary: [MediaItem] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model
class MediaItem {
    var title: String
    var url: URL  // Local file or remote
    var type: MediaType  // .video, .audio, .image
    
    enum MediaType: String, Codable, CaseIterable {
        case video, audio, image
    }
}
