import SwiftUI
import SwiftData

@Observable
final class SessionViewModel {
    var currentTopic: Topic?
    var previousTopics: [Topic] = []
    var isCardFlipped = false
    var sessionStartTime: Date?
    var selectedCategory: TopicCategory = .icebreaker
    var selectedDepth: ConversationDepth = .light

    private var allTopics: [Topic] = []
    private var unusedTopics: [Topic] = []

    func loadTopics(for category: TopicCategory, depth: ConversationDepth, context: ModelContext) {
        let repository = TopicRepository()
        allTopics = repository.fetchTopics(category: category, depth: depth, context: context)
        unusedTopics = allTopics.filter { topic in
            !previousTopics.contains(where: { $0.id == topic.id })
        }
        showNextTopic()
    }

    func showNextTopic() {
        if unusedTopics.isEmpty {
            unusedTopics = allTopics.filter { topic in
                !previousTopics.contains(where: { $0.id == topic.id })
            }
            if unusedTopics.isEmpty { unusedTopics = allTopics }
        }
        currentTopic = unusedTopics.randomElement()
        if let topic = currentTopic {
            unusedTopics.removeAll { $0.id == topic.id }
        }
        isCardFlipped = false
    }

    func flipCard() {
        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
            isCardFlipped.toggle()
        }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    func markAsUsed(_ topic: Topic, context: ModelContext) {
        topic.usageCount += 1
        topic.lastUsed = Date()
        previousTopics.append(topic)
        try? context.save()
    }

    func toggleFavorite(_ topic: Topic, context: ModelContext) {
        let repository = TopicRepository()
        repository.toggleFavorite(topic, context: context)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func startSession() {
        sessionStartTime = Date()
        previousTopics = []
    }

    func topicsUsedCount() -> Int {
        return previousTopics.count
    }
}
