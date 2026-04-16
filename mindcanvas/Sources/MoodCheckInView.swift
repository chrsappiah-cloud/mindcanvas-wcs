import SwiftUI

struct MoodCheckInView: View {
    @State private var mood: String = "😊"
    @State private var energy: Double = 5
    @State private var note: String = ""
    var body: some View {
        Form {
            Section(header: Text("Mood")) {
                Picker("Mood", selection: ) {
                    Text("😊").tag("😊")
                    Text("😐").tag("😐")
                    Text("😢").tag("😢")
                    Text("😡").tag("😡")
                }
                .pickerStyle(.segmented)
            }
            Section(header: Text("Energy")) {
                Slider(value: , in: 0...10, step: 1) {
                    Text("Energy")
                }
                Text("\(Int(energy))")
            }
            Section(header: Text("Reflection (optional)")) {
                TextField("How are you feeling?", text: )
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
