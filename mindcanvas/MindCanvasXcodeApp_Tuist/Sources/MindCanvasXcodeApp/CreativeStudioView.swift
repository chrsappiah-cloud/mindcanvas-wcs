import CloudKit
import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct CreativeStudioView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    @State private var color: Color = .blue
    @State private var brushSize: Double = 10
    @State private var drawing = [CGPoint]()
    @State private var saveStatus: String?
    @State private var isLoading: Bool = false
    var body: some View {
        VStack {
            HStack {
                if #available(macOS 11.0, *) {
                    ColorPicker("Color", selection: $color)
                } else {
                    Text("Color Picker")
                }
                Slider(value: $brushSize, in: 1...30, label: { Text("Brush Size") })
            }
            .padding()
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 300)
                    .cornerRadius(16)
                    .overlay(
                        Path { path in
                            for (i, point) in drawing.enumerated() {
                                if i == 0 {
                                    path.move(to: point)
                                } else {
                                    path.addLine(to: point)
                                }
                            }
                        }
                        .stroke(color, lineWidth: brushSize)
                    )
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            drawing.append(value.location)
                        }
                        .onEnded { _ in }
                    )
            }
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    Button(action: {
                        isLoading = true
                        saveStatus = nil
                        cloudKitManager.saveCreativeEntry(color: color.description, brushSize: brushSize) { result in
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
                        cloudKitManager.fetchCreativeEntries { result in
                            isLoading = false
                            switch result {
                            case .success(_):
                                saveStatus = "Fetched latest creative entries."
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
        .padding()
        if #available(macOS 11.0, *) {
            self.navigationTitle("Creative Studio")
        }
            // Display fetched creative entries
            if !cloudKitManager.creativeEntries.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Creative Entries").font(.headline)
                    ForEach(cloudKitManager.creativeEntries, id: \.recordID) { record in
                        HStack {
                            Text("Color: \(record["color"] as? String ?? "")")
                            Text(String(format: "Brush: %.1f", record["brushSize"] as? Double ?? 0))
                            if let date = record["timestamp"] as? Date {
                                Text(DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short))
                            }
                        }
                        .font(.caption)
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
struct CreativeStudioView_Previews: PreviewProvider {
    static var previews: some View {
        CreativeStudioView()
    }
}
#endif