import SwiftUI
import PencilKit
import SwiftData

struct PaintingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(HealthManager.self) private var healthManager
    @Query private var sessions: [TherapySession]
    @State private var canvasView = PKCanvasView()
    @State private var selectedColor: Color = .black
    @State private var selectedTool: PKInkingTool.InkType = .pen
    @State private var lineWidth: CGFloat = 5.0
    @State private var sessionStartTime = Date()
    @State private var isSessionActive = false
    @State private var showingMoodSelector = false
    @State private var selectedMood: Mood = .neutral
    @State private var sessionNotes = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Canvas
                PKCanvasRepresentable(canvasView: $canvasView)
                    .frame(maxHeight: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                
                // Controls
                VStack(spacing: 15) {
                    // Colors
                    HStack {
                        ForEach(ColorPreset.allCases, id: \.self) { preset in
                            Circle()
                                .fill(preset.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == preset.color ? Color.white : Color.clear, lineWidth: 3)
                                )
                                .shadow(radius: selectedColor == preset.color ? 5 : 0)
                                .onTapGesture {
                                    selectedColor = preset.color
                                    updateTool()
                                }
                        }
                    }
                    
                    // Tools
                    HStack {
                        ForEach(PKInkingTool.InkType.allCases, id: \.self) { tool in
                            Image(systemName: tool.icon)
                                .font(.title2)
                                .foregroundColor(selectedTool == tool ? .blue : .gray)
                                .onTapGesture {
                                    selectedTool = tool
                                    updateTool()
                                }
                        }
                    }
                    
                    // Session Controls
                    HStack {
                        if isSessionActive {
                            Button("End Session") {
                                endSession()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        } else {
                            Button("Start Session") {
                                startSession()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        Button("Clear") {
                            canvasView.drawing = PKDrawing()
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
            .navigationTitle("🎨 Creative Painting")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingMoodSelector) {
                MoodSelectorView(
                    selectedMood: $selectedMood,
                    notes: $sessionNotes,
                    onSave: saveSession
                )
            }
            .task {
                await healthManager.requestAuthorization()
                canvasView.tool = PKInkingTool(.pen, color: UIColor(selectedColor), width: lineWidth)
            }
        }
    }
    
    private func startSession() {
        isSessionActive = true
        sessionStartTime = Date()
    }
    
    private func endSession() {
        isSessionActive = false
        showingMoodSelector = true
    }
    
    private func saveSession() {
        let duration = -sessionStartTime.timeIntervalSinceNow
        let drawingsData = try? NSKeyedArchiver.archivedData(
            withRootObject: canvasView.drawing,
            requiringSecureCoding: true
        )
        
        let session = TherapySession(
            mood: selectedMood,
            duration: duration,
            activityType: .painting,
            drawingsData: drawingsData,
            notes: sessionNotes.isEmpty ? nil : sessionNotes
        )
        
        modelContext.insert(session)
        try? modelContext.save()
        
        // Log to HealthKit
        Task {
            await healthManager.logMoodSession(
                mood: selectedMood,
                duration: duration,
                notes: sessionNotes
            )
        }
        
        // Reset
        canvasView.drawing = PKDrawing()
        sessionNotes = ""
    }
    
    private func updateTool() {
        canvasView.tool = PKInkingTool(selectedTool, color: UIColor(selectedColor), width: lineWidth)
    }
}

struct PKCanvasRepresentable: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .white
        canvas.isOpaque = true
        canvas.allowsFingerDrawing = true
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawing = canvasView.drawing
    }
}

extension PKInkingTool.InkType {
    var icon: String {
        switch self {
        case .pen: return "pencil"
        case .marker: return "marker"
        case .pencil: return "pencil.tip"
        @unknown default: return "pencil"
        }
    }
}

extension ColorPreset {
    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .purple: return .purple
        case .orange: return .orange
        case .pink: return .pink
        }
    }
}

struct MoodSelectorView: View {
    @Binding var selectedMood: Mood
    @Binding var notes: String
    var onSave: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("How are you feeling?")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                    ForEach(Mood.allCases, id: \.self) { mood in
                        Button(mood.rawValue) {
                            selectedMood = mood
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(moodColor(mood))
                        .font(.headline)
                        .frame(height: 60)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes (optional)")
                        .font(.headline)
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                HStack {
                    Button("Cancel") { dismiss() }
                        .buttonStyle(.bordered)
                    Button("Save Session") {
                        onSave()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .disabled(selectedMood == .neutral)
                }
            }
            .padding()
            .navigationTitle("Session Complete")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func moodColor(_ mood: Mood) -> Color {
        switch mood {
        case .happy: return .yellow
        case .calm: return .green
        case .neutral: return .gray
        case .anxious: return .orange
        case .sad: return .blue
        }
    }
}
