import Foundation

@Model
class MediaItem {
    var title: String
    var fileURL: URL?
    var thumbnailData: Data?
    var duration: TimeInterval
    var mediaType: MediaType
    var category: String // "Family", "Nature", "Music", etc.
    
    enum MediaType: String, Codable, CaseIterable {
        case video, audio, image
    }
    
    init(title: String, fileURL: URL? = nil, duration: TimeInterval = 0, 
         mediaType: MediaType, category: String) {
        self.title = title
        self.fileURL = fileURL
        self.duration = duration
        self.mediaType = mediaType
        self.category = category
    }
}
