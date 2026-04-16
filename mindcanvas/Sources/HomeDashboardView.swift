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
