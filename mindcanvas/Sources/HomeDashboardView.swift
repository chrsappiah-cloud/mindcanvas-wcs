
import SwiftUI

@available(iOS 15.0, macOS 10.15, *)
struct HomeDashboardView: View {
    @EnvironmentObject var cloudKitManager: CloudKitManager
    var body: some View {
        if #available(macOS 13.0, *) {
            NavigationStack {
                VStack(spacing: 24) {
                    Text("MindCanvas")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 32)
                        .modifier(HeaderAccessibilityModifier())
                    VStack(spacing: 16) {
                        NavigationLink(destination: MoodCheckInView().environmentObject(cloudKitManager)) {
                            DashboardCard(title: "How do you feel today?", systemImage: "face.smiling")
                        }
                        .accessibilityLabel("Go to mood check-in")
                        NavigationLink(destination: CreativeStudioView().environmentObject(cloudKitManager)) {
                            DashboardCard(title: "Create something gentle", systemImage: "paintbrush.pointed")
                        }
                        .accessibilityLabel("Go to creative studio")
                        NavigationLink(destination: MemoryCardView().environmentObject(cloudKitManager)) {
                            DashboardCard(title: "Visit your memories", systemImage: "photo.on.rectangle")
                        }
                        .accessibilityLabel("Go to memory cards")
                        NavigationLink(destination: KindStepsView()) {
                            DashboardCard(title: "Today's kind steps", systemImage: "figure.walk")
                        }
                        .accessibilityLabel("Go to kind steps")
                        // Placeholder for future feature
                        DashboardCard(title: "Encouragement from your circle", systemImage: "person.2.circle")
                            .accessibilityLabel("Encouragement from your circle")
                    }
                    Spacer()
                }
                .padding()
            }
        } else {
            VStack(spacing: 24) {
                Text("MindCanvas")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 32)
                    .modifier(HeaderAccessibilityModifier())
                VStack(spacing: 16) {
                    Text("How do you feel today?")
                    Text("Create something gentle")
                    Text("Visit your memories")
                    Text("Today's kind steps")
                    Text("Encouragement from your circle")
                }
                Spacer()
            }
            .padding()
        }
    }
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
                    .accessibilityLabel(Text(title))
            } else {
                Text(systemImage)
            }
            Text(title)
                .font(.headline)
        }
        .padding()
        .frame(minHeight: 44)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .shadow(radius: 1)
        .accessibilityElement(children: .combine)
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
