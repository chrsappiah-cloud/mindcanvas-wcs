import HealthKit
import Foundation
import Observation

@MainActor
class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var authorizationStatus: HKAuthorizationStatus = .notDetermined
    
    func requestAuthorization() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let moodType = HKObjectType.seriesType(forIdentifier: .stateOfMind)!
        let typesToRead: Set<HKObjectType> = [moodType]
        
        do {
            authorizationStatus = .sharingDenied
            try await healthStore.requestAuthorization(toShare: nil, read: typesToRead)
            authorizationStatus = .sharingAuthorized
        } catch {
            print("HealthKit authorization failed: \(error)")
            authorizationStatus = .sharingDenied
        }
    }
    
    func logMoodSession(mood: Mood, duration: TimeInterval, notes: String?) async {
        guard authorizationStatus == .sharingAuthorized else { return }
        
        let sessionStart = Date().addingTimeInterval(-duration)
        let sessionEnd = Date()
        
        let stateOfMind = HKStateOfMindSample(
            dateInterval: DateInterval(start: sessionStart, end: sessionEnd),
            categoryValue: convertMoodToCategory(mood),
            userReported: true,
            notes: notes
        )
        
        do {
            try await healthStore.save(stateOfMind)
        } catch {
            print("Failed to save mood: \(error)")
        }
    }
    
    private func convertMoodToCategory(_ mood: Mood) -> UInt {
        switch mood {
        case .happy: return 0
        case .calm: return 1
        case .neutral: return 2
        case .anxious: return 3
        case .sad: return 4
        }
    }
}
