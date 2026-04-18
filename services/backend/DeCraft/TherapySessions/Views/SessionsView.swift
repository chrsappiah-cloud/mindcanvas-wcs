import SwiftUI
import SwiftData
import Charts

struct SessionsView: View {
    @Query(sort: \TherapySession.date, order: .reverse) private var sessions: [TherapySession]
    @State private var selectedSession: TherapySession?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationStack {
            List(sessions) { session in
                SessionRow(session: session)
                    .onTapGesture {
                        selectedSession = session
                        showingDetail = true
                    }
            }
            .navigationTitle("📊 Therapy Sessions")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedSession) { session in
                SessionDetailView(session: session)
            }
            .overlay {
                if sessions.isEmpty {
                    ContentUnavailableView(
                        "No Sessions Yet",
                        systemImage: "calendar.badge.clock",
                        description: Text("Start a painting or media session to track progress.")
                    )
                }
            }
        }
    }
}

struct SessionRow: View {
    let session: TherapySession
    
    var body: some View {
        HStack {
            Image(systemName: session.activityType.icon)
                .font(.title2)
                .foregroundStyle(session.mood.color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.activityType.rawValue)
                    .font(.headline)
                Text(session.mood.rawValue)
                    .font(.subheadline)
                    .foregroundStyle(session.mood.color.opacity(0.8))
                Text(formatDuration(session.duration))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(formatDate(session.date))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        return "\(minutes):\(seconds < 10 ? \"0\" : \"\")\(seconds)"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct SessionDetailView: View {
    let session: TherapySession
    @Environment(\.dismiss) private var dismiss
    @State private var showingDrawing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Image(systemName: session.activityType.icon)
                            .font(.system(size: 50))
                            .foregroundStyle(session.mood.color)
                        VStack(alignment: .leading) {
                            Text(session.activityType.rawValue)
                                .font(.title)
                        }
                    Grid {
                        GridRow {
                            Label("Duration", systemImage: "clock")
                            Text(formatDuration(session.duration))
                        }
                        GridRow {
                            Label("Date", systemImage: "calendar")
                            Text(formatDate(session.date))
                        }
                    }
                    .font(.headline)
                    
                    // Notes
                    if let notes = session.notes, !notes.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Notes")
                                .font(.headline)
                            Text(notes)
                                .font(.body)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    // Drawing Preview
                                import SwiftData
                                struct SessionsView: View {
                                    @Query(sort: \TherapySession.date, order: .reverse) private var sessions: [TherapySession]
                                    var body: some View {
                                        NavigationStack {
                                            List(sessions) { session in
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text("Session on \(session.date, formatter: dateFormatter)")
                                                        .font(.headline)
                                                    Text("Mood: \(session.mood.rawValue.capitalized)")
                                                    Text("Duration: \(session.duration, specifier: "%.0f") seconds")
                                                    if let notes = session.notes, !notes.isEmpty {
                                                        Text("Notes: \(notes)")
                                                    }
                                                }
                                            }
                                            .navigationTitle("Sessions")
                                        }
                                    }
                                }
                                private let dateFormatter: DateFormatter = {
                                    let df = DateFormatter()
                                    df.dateStyle = .medium
                                    df.timeStyle = .short
                                    return df
                                }()
                    if session.drawingsData != nil {
                        Button("View Drawing") {
                            showingDrawing = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
            }
            .navigationTitle("Session Details")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingDrawing) {
                DrawingPreview(drawingData: session.drawingsData)
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
        return "\(minutes) min \(seconds) sec"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DrawingPreview: View {
    let drawingData: Data?
    @Environment(\.dismiss) private var dismiss
    @State private var canvasView = PKCanvasView()
    
    var body: some View {
        NavigationStack {
            VStack {
                PKCanvasRepresentable(canvasView: $canvasView)
                    .frame(maxHeight: .infinity)
                    .background(Color.white)
                    .navigationTitle("Your Artwork")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                loadDrawing()
            }
        }
    }
    
    private func loadDrawing() {
        guard let data = drawingData,
              let drawing = try? NSKeyedUnarchiver.unarchivedObject(
                ofClass: PKDrawing.self,
                from: data
              ) else { return }
        canvasView.drawing = drawing
    }
}
