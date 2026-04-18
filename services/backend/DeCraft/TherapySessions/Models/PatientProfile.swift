import SwiftData

@Model
class PatientProfile {
    var name: String
    var caregiverName: String?
    var preferredColors: [ColorPreset]
    var mediaLibrary: [MediaItem]
    
    init(name: String, caregiverName: String? = nil) {
        self.name = name
        self.caregiverName = caregiverName
        self.preferredColors = [.blue, .green]
        self.mediaLibrary = []
    }
}

enum ColorPreset: String, CaseIterable {
    case blue = "Blue"
    case green = "Green"
    case purple = "Purple"
    case orange = "Orange"
    case pink = "Pink"
}
