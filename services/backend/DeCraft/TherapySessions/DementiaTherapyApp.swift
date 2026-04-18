@main
struct DementiaTherapyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [TherapySession.self, PatientProfile.self, MediaItem.self])
        }
    }
}

struct ContentView: View {
    @Query private var sessions: [TherapySession]
    @State private var selectedTab = 0
    @Environment(HealthManager.self) private var healthManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PaintingView()
                .tabItem { Label("Paint", systemImage: "paintbrush") }
            MediaLibraryView()
                .tabItem { Label("Memories", systemImage: "photo") }
            SessionsView(sessions: sessions)
                .tabItem { Label("Sessions", systemImage: "calendar") }
        }
        .task { await healthManager.requestMoodAccess() }
        .onAppear { /* Load profile */ }
    }
}
