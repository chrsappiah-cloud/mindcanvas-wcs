import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [PatientProfile]
    @State private var selectedTab = 0
    @State private var showingProfileSetup = false
    @Environment(HealthManager.self) private var healthManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PaintingView()
                .tabItem {
                    Label("🎨 Painting", systemImage: "paintbrush")
                }
                .tag(0)
            
            MediaLibraryView()
                .tabItem {
                    Label("📸 Memories", systemImage: "photo.on.rectangle")
                }
                .tag(1)
            
            SessionsView()
                .tabItem {
                    Label("📊 Progress", systemImage: "chart.bar")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .task {
            await healthManager.requestAuthorization()
        }
        .sheet(isPresented: $showingProfileSetup) {
            ProfileSetupView()
        }
        .onAppear {
            if profiles.isEmpty {
                showingProfileSetup = true
            }
        }
    }
}

struct ProfileSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [PatientProfile]
    @State private var name = ""
    @State private var caregiverName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Patient Information") {
                    TextField("Patient Name", text: $name)
                    TextField("Caregiver Name (optional)", text: $caregiverName)
                }
                
                Section {
                    Button("Create Profile") {
                        let profile = PatientProfile(name: name, caregiverName: caregiverName.isEmpty ? nil : caregiverName)
                        modelContext.insert(profile)
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                } footer: {
                    Text("This profile enables personalized therapy tracking.")
                }
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
