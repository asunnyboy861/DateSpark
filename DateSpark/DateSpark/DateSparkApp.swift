import SwiftUI
import SwiftData

@main
struct DateSparkApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Topic.self, DateSession.self])
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var topicRepository = TopicRepository()

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }
                .tag(0)

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
        .onAppear {
            topicRepository.seedTopicsIfNeeded(context: modelContext)
        }
    }

    @Environment(\.modelContext) private var modelContext
}
