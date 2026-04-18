import AVKit

import SwiftUI
import AVKit

// Add your utility extensions here

extension AVPlayer {
    private struct AssociatedKeys {
        static var isLooping = "isLooping"
    }
    
    var isLooping: Bool {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.isLooping) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isLooping, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue {
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: currentItem, queue: .main) { [weak self] _ in
                    self?.seek(to: .zero)
                    self?.play()
                }
            } else {
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: currentItem)
            }
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

// Accessibility extensions
extension View {
    func dementiaAccessible() -> some View {
        self
            .dynamicTypeSize(.accessibility5)
            .minimumScaleFactor(0.5)
            .onAppear {
                UIAccessibility.post(notification: .screenChanged, argument: self)
            }
    }
}
