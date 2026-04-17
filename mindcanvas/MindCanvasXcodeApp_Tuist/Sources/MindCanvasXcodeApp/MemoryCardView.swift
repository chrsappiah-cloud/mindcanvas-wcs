import CloudKit
import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
@available(iOS 15.0, macOS 10.15, *)
struct MemoryCardView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var title: String = ""
    @State private var tags: String = ""
    @State private var note: String = ""
    @State private var saveStatus: String?
    @State private var isLoading: Bool = false
    @available(iOS 15.0, macOS 10.15, *)
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Memory Title", text: $title)
            }
            Section(header: Text("Tags")) {
                TextField("Tags (comma separated)", text: $tags)
            }
            Section(header: Text("Voice Note (optional)")) {
                TextField("Voice note path or description", text: $note)
            }
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Button(action: {
                        isLoading = true
                        saveStatus = nil
                        cloudKitManager.saveMemory(title: title, tags: tags, note: note) { result in
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
                        cloudKitManager.fetchMemories { result in
                            isLoading = false
                            switch result {
                            case .success(_):
                                saveStatus = "Fetched latest memories."
                            case .failure(let error):
                                saveStatus = "Error: \(error.localizedDescription)"
                            }
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
        if #available(macOS 11.0, *) {
            self.navigationTitle("Memory Card")
        }

        // Display fetched memories
        if !cloudKitManager.memories.isEmpty {
            Section(header: Text("Recent Memories").font(.headline)) {
                ForEach(cloudKitManager.memories, id: \.recordID) { record in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Title: \(record["title"] as? String ?? "")")
                            .font(.subheadline)
                        if let tags = record["tags"] as? String, !tags.isEmpty {
                            Text("Tags: \(tags)").font(.caption).foregroundColor(.secondary)
                        }
                        if let note = record["note"] as? String, !note.isEmpty {
                            if #available(macOS 11.0, *) {
                                Text("Note: \(note)").font(.caption2).foregroundColor(.secondary)
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
@available(iOS 15.0, macOS 10.15, *)
struct MemoryCardView_Previews: PreviewProvider {
    @available(iOS 15.0, macOS 10.15, *)
    static var previews: some View {
        MemoryCardView()
    }
}
#endif