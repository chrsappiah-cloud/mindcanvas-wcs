import SwiftUI

struct MemoryCardView: View {
    @State private var title: String = ""
    @State private var tags: String = ""
    @State private var note: String = ""
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Memory Title", text: )
            }
            Section(header: Text("Tags")) {
                TextField("Tags (comma separated)", text: )
            }
            Section(header: Text("Voice Note (optional)")) {
                TextField("Voice note path or description", text: )
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
