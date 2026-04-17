@available(macOS 10.15, *)
struct ButtonAccessibilityModifier: ViewModifier {
    let label: String
    let traits: AccessibilityTraits?
    @available(macOS 10.15, *)
    func body(content: Content) -> some View {
        if #available(macOS 11.0, *) {
            if let traits = traits {
                content.accessibilityLabel(label).accessibilityAddTraits(traits)
            } else {
                content.accessibilityLabel(label)
            }
        } else {
            content
        }
    }
}


import SwiftUI

// MARK: - Accessibility Helpers

@available(macOS 10.15, *)
struct HeaderAccessibilityModifier: ViewModifier {
    @available(macOS 10.15, *)
    func body(content: Content) -> some View {
        if #available(macOS 11.0, *) {
            content.accessibilityAddTraits(.isHeader)
        } else {
            content
        }
    }
}

@available(macOS 10.15, *)
struct LabelAccessibilityModifier: ViewModifier {
    let label: String
    let value: String?
    @available(macOS 10.15, *)
    func body(content: Content) -> some View {
        if #available(macOS 11.0, *) {
            if let value = value {
                content.accessibilityLabel(label).accessibilityValue(value)
            } else {
                content.accessibilityLabel(label)
            }
        } else {
            content
        }
    }
}

@available(macOS 10.15, *)
struct PrivacyAccessibilityModifier: ViewModifier {
    let hint: String
    let value: String
    @available(macOS 10.15, *)
    func body(content: Content) -> some View {
        var result: AnyView = AnyView(content)
        if #available(macOS 11.0, *) {
            result = AnyView(result.accessibilityHint(hint).accessibilityValue(value))
        }
        if #available(macOS 12.0, *) {
            result = AnyView(result.privacySensitive())
        }
        return result
    }
}

@available(iOS 15.0, macOS 10.15, *)
func sectionHeader(_ text: String) -> some View {
    Text(text).modifier(HeaderAccessibilityModifier())
}

@available(iOS 15.0, macOS 10.15, *)
struct MoodCheckInView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var mood: String = "😊"
    @State private var energy: Double = 5
    @State private var note: String = ""
    @State private var saveStatus: String?
    @State private var isLoading: Bool = false
    @available(iOS 15.0, macOS 10.15, *)
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    var body: some View {
        Form {
            Section(header: sectionHeader("Mood")) {
                Picker("Mood", selection: $mood) {
                    Text("😊").tag("😊").modifier(LabelAccessibilityModifier(label: "Happy", value: nil))
                    Text("😐").tag("😐").modifier(LabelAccessibilityModifier(label: "Neutral", value: nil))
                    Text("😢").tag("😢").modifier(LabelAccessibilityModifier(label: "Sad", value: nil))
                    Text("😡").tag("😡").modifier(LabelAccessibilityModifier(label: "Angry", value: nil))
                }
                .pickerStyle(.segmented)
                .modifier(LabelAccessibilityModifier(label: "Mood selection", value: mood))
            }
            Section(header: sectionHeader("Energy")) {
                Slider(value: $energy, in: 0...10, step: 1) {
                    Text("Energy")
                }
                .modifier(LabelAccessibilityModifier(label: "Energy level", value: "\(Int(energy))"))
                Text("\(Int(energy))")
            }
            Section(header: sectionHeader("Reflection (optional)")) {
                TextField("How are you feeling?", text: $note)
                    .modifier(PrivacyAccessibilityModifier(hint: "Describe your mood. Optional.", value: note))
            }
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Button(action: {
                        withAnimation(reduceMotion ? nil : .easeInOut) {
                            isLoading = true
                            saveStatus = nil
                        }
                        cloudKitManager.saveMood(mood: mood, energy: Int(energy), note: note) { result in
                            withAnimation(reduceMotion ? nil : .easeInOut) {
                                isLoading = false
                            }
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
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .padding()
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(10)
                        } else {
                            Text("Save")
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .padding()
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(10)
                        }
                    }
                    .modifier(ButtonAccessibilityModifier(label: "Save mood entry", traits: .isButton))
                    Button(action: {
                        withAnimation(reduceMotion ? nil : .easeInOut) {
                            isLoading = true
                            saveStatus = nil
                        }
                        cloudKitManager.fetchMoods()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(reduceMotion ? nil : .easeInOut) {
                                isLoading = false
                            }
                            saveStatus = "Fetched latest moods."
                        }
                    }) {
                        if #available(macOS 11.0, *) {
                            Label("Fetch", systemImage: "arrow.clockwise")
                                .frame(maxWidth: .infinity, minHeight: 44)
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
                        let mood = record["mood"] as? String ?? ""
                        let energy = record["energy"] as? Int ?? 0
                        Text("Mood: \(mood)  |  Energy: \(energy)")
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
