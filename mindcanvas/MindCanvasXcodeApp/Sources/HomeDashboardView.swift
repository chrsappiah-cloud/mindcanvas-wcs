import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct HomeDashboardView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    dashboardContent
                }
            } else {
                NavigationView {
                    dashboardContent
                }
            }
        }
    }
    private var dashboardContent: some View {
        VStack(spacing: 24) {
            Text("MindCanvas")
                .font(.largeTitle)
                .bold()
                .padding(.top, 32)
            VStack(spacing: 16) {
                NavigationLink(destination: MoodCheckInView().environmentObject(cloudKitManager)) {
                    DashboardCard(title: "How do you feel today?", systemImage: "face.smiling")
                }
                NavigationLink(destination: CreativeStudioView().environmentObject(cloudKitManager)) {
                    DashboardCard(title: "Create something gentle", systemImage: "paintbrush.pointed")
                }
                NavigationLink(destination: MemoryCardView().environmentObject(cloudKitManager)) {
                    DashboardCard(title: "Visit your memories", systemImage: "photo.on.rectangle")
                }
                NavigationLink(destination: KindStepsView()) {
                    DashboardCard(title: "Today's kind steps", systemImage: "figure.walk")
                }
                // Placeholder for future feature
                DashboardCard(title: "Encouragement from your circle", systemImage: "person.2.circle")
            }
            Spacer()
        }
        .padding()
    }
// ...existing code...
}

@available(iOS 15.0, macOS 10.15, *)
struct DashboardCard: View {
    let title: String
    let systemImage: String
    @available(iOS 15.0, macOS 10.15, *)
    var body: some View {
        HStack {
            if #available(macOS 11.0, *) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundColor(.accentColor)
            } else {
                Text(systemImage)
            }
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

#if DEBUG
@available(iOS 15.0, *)
struct HomeDashboardView_Previews: PreviewProvider {
    @available(iOS 15.0, macOS 10.15, *)
    static var previews: some View {
        HomeDashboardView()
    }
}
#endif