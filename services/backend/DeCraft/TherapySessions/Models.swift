import Foundation
import SwiftData

enum Mood: String, Codable, CaseIterable {
    case happy, calm, neutral, anxious, sad
}
enum ActivityType: String, Codable, CaseIterable {
    case painting, music, video, photo
}
enum MediaType: String, Codable, CaseIterable {
    case video, audio, image
}
@Model
final class TherapySession {
    var id: UUID
    var date: Date
    var moodRaw: String
    var duration: Double
    var activityTypeRaw: String
    var drawingsData: Data?
    var mediaFileURLStrings: [String]
    var notes: String?
    init(
        id: UUID = UUID(),
        date: Date = .now,
        mood: Mood = .neutral,
        duration: Double = 0,
        activityType: ActivityType = .painting,
        drawingsData: Data? = nil,
        mediaFileURLStrings: [String] = [],
        notes: String? = nil
    ) {
        self.id = id
        self.date = date
        self.moodRaw = mood.rawValue
        self.duration = duration
        self.activityTypeRaw = activityType.rawValue
        self.drawingsData = drawingsData
        self.mediaFileURLStrings = mediaFileURLStrings
        self.notes = notes
    }
    var mood: Mood {
        Mood(rawValue: moodRaw) ?? .neutral
    }
    var activityType: ActivityType {
        ActivityType(rawValue: activityTypeRaw) ?? .painting
    }
}
@Model
final class PatientProfile {
    var id: UUID
    var name: String
    var caregiverName: String?
    init(id: UUID = UUID(), name: String, caregiverName: String? = nil) {
        self.id = id
        self.name = name
        self.caregiverName = caregiverName
    }
}
@Model
final class MediaItem {
    var id: UUID
    var title: String
    var fileURLString: String?
    var thumbnailData: Data?
    var duration: Double
    var mediaTypeRaw: String
    var category: String
    init(
        id: UUID = UUID(),
        title: String,
        fileURLString: String? = nil,
        thumbnailData: Data? = nil,
        duration: Double = 0,
        mediaType: MediaType,
        category: String
    ) {
        self.id = id
        self.title = title
        self.fileURLString = fileURLString
        self.thumbnailData = thumbnailData
        self.duration = duration
        self.mediaTypeRaw = mediaType.rawValue
        self.category = category
    }
    var fileURL: URL? {
        guard let fileURLString else { return nil }
        return URL(string: fileURLString)
    }
    var mediaType: MediaType {
        MediaType(rawValue: mediaTypeRaw) ?? .image
    }
}
