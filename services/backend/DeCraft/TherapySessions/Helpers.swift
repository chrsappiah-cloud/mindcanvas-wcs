import SwiftUI
import AVKit
extension Mood {
    var color: Color {
        switch self {
        case .happy: return .yellow
        case .calm: return .green
        case .neutral: return .gray
        case .anxious: return .orange
        case .sad: return .blue
        }
    }
}
extension ActivityType {
    var icon: String {
        switch self {
        case .painting: return "paintbrush"
        case .music: return "music.note"
        case .video: return "video"
        case .photo: return "photo"
        }
    }
}
extension MediaType {
    var icon: String {
        switch self {
        case .video: return "video"
        case .audio: return "waveform"
        case .image: return "photo"
        }
    }
}
