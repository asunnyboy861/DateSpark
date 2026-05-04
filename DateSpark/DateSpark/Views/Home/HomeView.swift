import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedCategory: TopicCategory?
    @State private var selectedDepth: ConversationDepth = .light

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    depthPicker
                    categoryGrid
                }
                .padding()
                .iPadMaxWidth()
            }
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $selectedCategory) { category in
                SessionView(category: category, depth: selectedDepth)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("DateSpark")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Never run out of things to say")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    private var depthPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Choose your vibe")
                .font(.headline)
                .padding(.horizontal, 4)

            HStack(spacing: 12) {
                ForEach(ConversationDepth.allCases, id: \.self) { depth in
                    DepthButton(depth: depth, isSelected: selectedDepth == depth) {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedDepth = depth
                        }
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                }
            }
        }
    }

    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pick a category")
                .font(.headline)
                .padding(.horizontal, 4)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(TopicCategory.allCases, id: \.self) { category in
                    CategoryCard(category: category) {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct DepthButton: View {
    let depth: ConversationDepth
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: depth.emoji)
                    .font(.caption)
                Text(depth.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                isSelected ? Color(hex: depth.colorHex) : Color(.systemBackground),
                in: Capsule()
            )
            .foregroundStyle(isSelected ? .white : .primary)
            .overlay(
                Capsule().stroke(Color(hex: depth.colorHex).opacity(isSelected ? 0 : 0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct CategoryCard: View {
    let category: TopicCategory
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundStyle(Color(hex: category.colorHex))
                    .frame(height: 28)

                Text(category.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, minHeight: 90)
            .padding()
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [Topic.self, DateSession.self])
}
