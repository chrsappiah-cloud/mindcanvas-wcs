import SwiftUI
import CloudKit

@available(iOS 15.0, macOS 10.15, *)
struct MoodCheckInView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var mood: String = "😊"
    @State private var energy: Double = 5
    @State private var note: String = ""
    @State private var saveStatus: String?
    @State private var isLoading: Bool = false
    @available(iOS 15.0, macOS 10.15, *)
    var body: some View {
        Form {
            Section(header: Text("Mood")) {
                Picker("Mood", selection: $mood) {
                    Text("😊").tag("😊")
                    Text("😐").tag("😐")
                    Text("😢").tag("😢")
                    Text("😡").tag("😡")
                }
                .pickerStyle(.segmented)
            }
            Section(header: Text("Energy")) {
                Slider(value: $energy, in: 0...10, step: 1) {
                    Text("Energy")
                }
                Text("\(Int(energy))")
            }
            Section(header: Text("Reflection (optional)")) {
                TextField("How are you feeling?", text: $note)
            }
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Button(action: {
                        isLoading = true
                        saveStatus = nil
                        cloudKitManager.saveMood(mood: mood, energy: Int(energy), note: note) { result in
                            isLoading = false
                            switch result {
                            case .success(_):
                                saveStatus = "Saved!"
                            case .failure(let error):
                                saveStatus = "Error: \(error.localizedDescription)"
                            }
                        }
                    }) {
                        if #available(macOS 11.0, *) {
                            Label("Save", systemImage: "tray.and.arrow.down.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(10)
                        } else {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(10)
                        }
                    }
                    Button(action: {
                        isLoading = true
                        saveStatus = nil
                        cloudKitManager.fetchMoods()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isLoading = false
                            saveStatus = "Fetched latest moods."
                        }
                    }) {
                        if #available(macOS 11.0, *) {
                            Label("Fetch", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        } else {
                            Text("Fetch")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                if isLoading {
                    if #available(macOS 11.0, *) {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Loading...")
                    }
                }
                if let saveStatus = saveStatus {
                    Text(saveStatus)
                        .foregroundColor(saveStatus == "Saved!" || saveStatus.contains("Fetched") ? .green : .red)
                        .font(.subheadline)
                        .padding(.top, 4)
                }
            }
        }
        .modifier(NavigationTitleModifierMoodCheckIn())

        // Display fetched moods
        if !cloudKitManager.moods.isEmpty {
            Section(header: Text("Recent Mood Entries").font(.headline)) {
                ForEach(cloudKitManager.moods, id: \.recordID) { record in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mood: \(record["mood"] as? String ?? "")  |  Energy: \(record["energy"] as? Int ?? 0)")
                            .font(.subheadline)
                        if let note = record["note"] as? String, !note.isEmpty {
                            if #available(macOS 11.0, *) {
                                Text("Note: \(note)").font(.caption).foregroundColor(.secondary)
                            } else {
                                Text("Note: \(note)").foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(6)
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(8)
                }
            }
            .padding([.top, .horizontal])
        }
    }
}

#if DEBUG
@available(iOS 15.0, *)
struct MoodCheckInView_Previews: PreviewProvider {
    @available(iOS 15.0, macOS 10.15, *)
    static var previews: some View {
        MoodCheckInView().environmentObject(CloudKitManager())
    }
}
#endif