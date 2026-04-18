import SwiftUI
import SwiftData
struct ContentView: View {
    @Environment(HealthManager.self) private var healthManager
    @Query private var profiles: [PatientProfile]
    @State private var selectedTab = 0
    @State private var showingProfileSetup = false
    var body: some View {
        TabView(selection: $selectedTab) {
            PaintingView()
                .tabItem { Label("Paint", systemImage: "paintbrush") }
                .tag(0)
            MediaLibraryView()
                .tabItem { Label("Media", systemImage: "photo.on.rectangle") }
                .tag(1)
            SessionsView()
                .tabItem { Label("Sessions", systemImage: "calendar") }
                .tag(2)
        }
        .task {
            await healthManager.requestAuthorization()
        }
        .onAppear {
            if profiles.isEmpty {
                showingProfileSetup = true
            }
        }
        .sheet(isPresented: $showingProfileSetup) {
            ProfileSetupView()
        }
    }
}
struct ProfileSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var caregiverName = ""
    var body: some View {
        NavigationStack {
            Form {
                Section("Patient") {
                    TextField("Name", text: $name)
                    TextField("Caregiver", text: $caregiverName)
                }
                Button("Create Profile") {
                    let profile = PatientProfile(
                        name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                        caregiverName: caregiverName.isEmpty ? nil : caregiverName
                    )
                    modelContext.insert(profile)
                    try? modelContext.save()
                    dismiss()
                }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationTitle("Setup")
        }
    }
}
