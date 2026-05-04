import SwiftUI
import SwiftData

struct SessionView: View {
    let category: TopicCategory
    let depth: ConversationDepth

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SessionViewModel()
    @State private var dragOffset: CGFloat = 0
    @State private var dragRotation: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            depthIndicator
            Spacer()
            cardArea
            Spacer()
            actionButtons
            progressDots
        }
        .padding()
        .iPadMaxWidth()
        .background(Color(.systemGroupedBackground))
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.startSession()
            viewModel.loadTopics(for: category, depth: depth, context: modelContext)
        }
    }

    private var depthIndicator: some View {
        HStack(spacing: 6) {
            Image(systemName: depth.emoji)
                .font(.caption)
            Text(depth.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(hex: depth.colorHex).opacity(0.15), in: Capsule())
        .foregroundStyle(Color(hex: depth.colorHex))
    }

    private var cardArea: some View {
        Group {
            if let topic = viewModel.currentTopic {
                TopicCardView(
                    topic: topic,
                    isFlipped: $viewModel.isCardFlipped,
                    onFlip: { viewModel.flipCard() },
                    onNext: {
                        viewModel.markAsUsed(topic, context: modelContext)
                        withAnimation(.spring(duration: 0.4)) {
                            viewModel.showNextTopic()
                        }
                    },
                    onFavorite: {
                        viewModel.toggleFavorite(topic, context: modelContext)
                    }
                )
                .offset(x: dragOffset)
                .rotationEffect(.degrees(dragRotation))
                .gesture(dragGesture)
            } else {
                emptyState
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No topics available")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text("Try a different category or depth level")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24))
    }

    private var actionButtons: some View {
        HStack(spacing: 32) {
            Button {
                if let topic = viewModel.currentTopic {
                    viewModel.toggleFavorite(topic, context: modelContext)
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: viewModel.currentTopic?.isFavorite == true ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundStyle(.pink)
                    Text("Save")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Button {
                if let topic = viewModel.currentTopic {
                    viewModel.markAsUsed(topic, context: modelContext)
                    withAnimation(.spring(duration: 0.4)) {
                        viewModel.showNextTopic()
                    }
                }
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color(hex: depth.colorHex))
                    Text("Next")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 16)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(index < viewModel.topicsUsedCount() ? Color(hex: depth.colorHex) : Color(.systemGray4))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.bottom, 8)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
                dragRotation = Double(value.translation.width) / 20
            }
            .onEnded { value in
                if abs(value.translation.width) > 100 {
                    withAnimation(.easeOut(duration: 0.3)) {
                        dragOffset = value.translation.width > 0 ? 500 : -500
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let topic = viewModel.currentTopic {
                            viewModel.markAsUsed(topic, context: modelContext)
                        }
                        dragOffset = 0
                        dragRotation = 0
                        viewModel.showNextTopic()
                    }
                } else {
                    withAnimation(.spring()) {
                        dragOffset = 0
                        dragRotation = 0
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        SessionView(category: .icebreaker, depth: .light)
            .modelContainer(for: [Topic.self, DateSession.self])
    }
}
