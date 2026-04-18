import SwiftUI
import PencilKit
import SwiftData
struct PaintingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(HealthManager.self) private var healthManager
    @State private var canvasView = PKCanvasView()
    @State private var inkType: PKInkingTool.InkType = .pen
    @State private var selectedColor: Color = .black
    @State private var isSessionActive = false
    @State private var sessionStart = Date()
    @State private var selectedMood: Mood = .neutral
    @State private var notes = ""
    @State private var showMoodSheet = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                CanvasHost(canvasView: $canvasView)
                    .frame(maxHeight: .infinity)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.gray.opacity(0.3)))
                    .padding()
                HStack {
                    ForEach([Color.black, .red, .blue, .green, .orange, .purple], id: \.self) { c in
                        Circle()
                            .fill(c)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                selectedColor = c
                                applyTool()
                            }
                    }
                }
                HStack {
                    Button(isSessionActive ? "End Session" : "Start Session") {
                        if isSessionActive {
                            showMoodSheet = true
                        } else {
                            isSessionActive = true
                            sessionStart = Date()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Clear") {
                        canvasView.drawing = PKDrawing()
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.bottom)
            }
            .navigationTitle("Painting")
            .sheet(isPresented: $showMoodSheet) {
                NavigationStack {
                    Form {
                        Picker("Mood", selection: $selectedMood) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                Text(mood.rawValue.capitalized).tag(mood)
                            }
                        }
                        TextField("Notes", text: $notes, axis: .vertical)
                        Button("Save") {
                            saveSession()
                            showMoodSheet = false
                            isSessionActive = false
                        }
                    }
                    .navigationTitle("Session")
                }
            }
            .onAppear {
                applyTool()
            }
        }
    }
    private func applyTool() {
        canvasView.tool = PKInkingTool(inkType, color: UIColor(selectedColor), width: 5)
        canvasView.drawingPolicy = .anyInput
    }
    private func saveSession() {
        let duration = Date().timeIntervalSince(sessionStart)
        let data = try? NSKeyedArchiver.archivedData(withRootObject: canvasView.drawing, requiringSecureCoding: true)
        let session = TherapySession(
            mood: selectedMood,
            duration: duration,
            activityType: .painting,
            drawingsData: data,
            notes: notes.isEmpty ? nil : notes
        )
        modelContext.insert(session)
        try? modelContext.save()
    }
}
struct CanvasHost: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.backgroundColor = .white
        canvasView.isOpaque = true
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .white
        canvasView.isOpaque = true
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}
