import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = TopicViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.favorites.isEmpty {
                    emptyState
                } else {
                    favoritesList
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites(context: modelContext)
            }
        }
    }

    private var emptyState: some View {
        ContentUnavailableView(
            "No Favorites Yet",
            systemImage: "heart",
            description: Text("Save topics you love during your date sessions")
        )
    }

    private var favoritesList: some View {
        List {
            ForEach(viewModel.favorites) { topic in
                FavoriteRow(topic: topic) {
                    viewModel.removeFavorite(topic, context: modelContext)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct FavoriteRow: View {
    let topic: Topic
    let onRemove: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.text)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(3)

                if !topic.followUp.isEmpty {
                    Text(topic.followUp)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 8) {
                    Label(topic.category.rawValue, systemImage: topic.category.icon)
                    Label(topic.depth.rawValue, systemImage: topic.depth.emoji)
                }
                .font(.caption2)
                .foregroundStyle(.tertiary)
            }

            Button(action: onRemove) {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: [Topic.self, DateSession.self])
}
