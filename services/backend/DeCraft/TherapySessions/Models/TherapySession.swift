import SwiftData
@Model
class TherapySession {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mood: Mood
    var duration: TimeInterval
    var activityType: ActivityType
    var drawingsData: Data?
    var mediaFileURLs: [URL]
    var notes: String?
    
    init(id: UUID = UUID(), date: Date = Date(), mood: Mood = .neutral, 
         duration: TimeInterval = 0, activityType: ActivityType = .painting,
         drawingsData: Data? = nil, mediaFileURLs: [URL] = [], notes: String? = nil) {
        self.id = id
        self.date = date
        self.mood = mood
        self.duration = duration
        self.activityType = activityType
        self.drawingsData = drawingsData
        self.mediaFileURLs = mediaFileURLs
        self.notes = notes
    }
}

enum Mood: String, CaseIterable {
    case happy = "Happy"
    case calm = "Calm"
    case neutral = "Neutral"
    case anxious = "Anxious"
    case sad = "Sad"
}

enum ActivityType: String, CaseIterable {
    case painting = "Painting"
    case music = "Music"
    case video = "Video"
    case photo = "Photo Gallery"
}
