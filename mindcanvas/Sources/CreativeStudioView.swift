import SwiftUI

struct CreativeStudioView: View {
    @State private var color: Color = .blue
    @State private var brushSize: Double = 10
    @State private var drawing = [CGPoint]()
    var body: some View {
        VStack {
            HStack {
                ColorPicker("Color", selection: )
                Slider(value: , in: 1...30, label: { Text("Brush Size") })
            }
            .padding()
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
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
            Button("Save to Journal") {
                // Save action
            }
            .padding()
        }
        .navigationTitle("Creative Studio")
    }
}

#Preview {
    CreativeStudioView()
}
