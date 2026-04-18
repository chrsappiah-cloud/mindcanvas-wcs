import SwiftUI

struct HealthTrackingView: View {
    @Environment(HealthManager.self) private var healthManager
    @State private var moods: [String] = []
    
    var body: some View {
        VStack {
            Text("Recent Moods")
                .font(.headline)
            List(moods, id: \.self) { mood in
                Text(mood)
            }
            Button("Fetch Recent Moods") {
                Task {
                    moods = await healthManager.fetchRecentMoods()
                }
            }
        }
        .padding()
    }
}
