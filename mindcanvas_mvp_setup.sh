#!/bin/bash
# Automated MindCanvas MVP SwiftUI project scaffolding script
# Usage: ./mindcanvas_mvp_setup.sh /path/to/your/projects

set -e

# 1. Setup directories
ROOT_DIR="$1/mindcanvas"
SRC_DIR="$ROOT_DIR/Sources"
TEST_DIR="$ROOT_DIR/Tests"

mkdir -p "$SRC_DIR"
mkdir -p "$TEST_DIR"

# 2. Create Swift Package manifest
cat > "$ROOT_DIR/Package.swift" <<EOL
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MindCanvas",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "MindCanvas",
            targets: ["MindCanvas"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MindCanvas",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "MindCanvasTests",
            dependencies: ["MindCanvas"],
            path: "Tests"
        ),
    ]
)
EOL

# 3. Create README
cat > "$ROOT_DIR/README.md" <<EOL
# MindCanvas

Apple-native iOS MVP for dementia support, mood relief, and motivation through digital creative arts.

## Features
- Paint your feeling
- Remember a beautiful moment
- Take one kind step today

## Tech
- SwiftUI
- CloudKit
- Xcode/Xcode Cloud
EOL

# 4. Create SwiftUI files
cat > "$SRC_DIR/MindCanvasApp.swift" <<EOL
import SwiftUI

@main
struct MindCanvasApp: App {
    var body: some Scene {
        WindowGroup {
            HomeDashboardView()
        }
    }
}
EOL

cat > "$SRC_DIR/HomeDashboardView.swift" <<EOL
import SwiftUI

struct HomeDashboardView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("MindCanvas")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 32)
                VStack(spacing: 16) {
                    DashboardCard(title: "How do you feel today?", systemImage: "face.smiling")
                    DashboardCard(title: "Create something gentle", systemImage: "paintbrush.pointed")
                    DashboardCard(title: "Visit your memories", systemImage: "photo.on.rectangle")
                    DashboardCard(title: "Today's kind steps", systemImage: "figure.walk")
                    DashboardCard(title: "Encouragement from your circle", systemImage: "person.2.circle")
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct DashboardCard: View {
    let title: String
    let systemImage: String
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.accentColor)
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

#Preview {
    HomeDashboardView()
}
EOL

cat > "$SRC_DIR/MoodCheckInView.swift" <<EOL
import SwiftUI

struct MoodCheckInView: View {
    @State private var mood: String = "😊"
    @State private var energy: Double = 5
    @State private var note: String = ""
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
            Button("Save") {
                // Save action
            }
        }
        .navigationTitle("Mood Check-In")
    }
}

#Preview {
    MoodCheckInView()
}
EOL

cat > "$SRC_DIR/CreativeStudioView.swift" <<EOL
import SwiftUI

struct CreativeStudioView: View {
    @State private var color: Color = .blue
    @State private var brushSize: Double = 10
    @State private var drawing = [CGPoint]()
    var body: some View {
        VStack {
            HStack {
                ColorPicker("Color", selection: $color)
                Slider(value: $brushSize, in: 1...30, label: { Text("Brush Size") })
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
EOL

cat > "$SRC_DIR/MemoryCardView.swift" <<EOL
import SwiftUI

struct MemoryCardView: View {
    @State private var title: String = ""
    @State private var tags: String = ""
    @State private var note: String = ""
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
            Button("Save Memory") {
                // Save action
            }
        }
        .navigationTitle("Memory Card")
    }
}

#Preview {
    MemoryCardView()
}
EOL

cat > "$SRC_DIR/KindStepsView.swift" <<EOL
import SwiftUI

struct KindStepsView: View {
    let steps = [
        "Hydration",
        "Breathing",
        "Gratitude",
        "Stretching",
        "Affirmation"
    ]
    var body: some View {
        List(steps, id: \.self) { step in
            HStack {
                Image(systemName: "checkmark.circle")
                Text(step)
            }
        }
        .navigationTitle("Kind Steps")
    }
}

#Preview {
    KindStepsView()
}
EOL

# 5. Create Xcode project if xcodeproj is available
if command -v xcodebuild >/dev/null 2>&1; then
    cd "$ROOT_DIR"
    xcodebuild -project MindCanvas.xcodeproj || echo "(If project does not exist, create it in Xcode and add the Sources files.)"
    cd -
fi

echo "MindCanvas MVP Swift package and source files scaffolded at $ROOT_DIR."
echo "Open in Xcode, add the Sources files to your project, and start building!"
