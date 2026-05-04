import SwiftUI
import SwiftData

@Observable
final class TopicViewModel {
    var favorites: [Topic] = []
    var isLoading = false

    func loadFavorites(context: ModelContext) {
        let repository = TopicRepository()
        favorites = repository.fetchFavorites(context: context)
    }

    func removeFavorite(_ topic: Topic, context: ModelContext) {
        let repository = TopicRepository()
        repository.toggleFavorite(topic, context: context)
        loadFavorites(context: context)
    }
}
