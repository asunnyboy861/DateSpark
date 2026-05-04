import SwiftData
import Foundation

enum TopicCategory: String, Codable, CaseIterable {
    case icebreaker = "Ice Breakers"
    case travel = "Travel & Adventure"
    case food = "Food & Culture"
    case entertainment = "Movies & Music"
    case values = "Values & Beliefs"
    case dreams = "Dreams & Goals"
    case fun = "Fun & Games"
    case deep = "Deep Connection"
    case couples = "For Couples"

    var icon: String {
        switch self {
        case .icebreaker: return "snowflake"
        case .travel: return "airplane"
        case .food: return "fork.knife"
        case .entertainment: return "film"
        case .values: return "heart.text.square"
        case .dreams: return "star"
        case .fun: return "gamecontroller"
        case .deep: return "moon.stars"
        case .couples: return "heart.circle"
        }
    }

    var colorHex: String {
        switch self {
        case .icebreaker: return "64D2FF"
        case .travel: return "30D158"
        case .food: return "FF9F0A"
        case .entertainment: return "BF5AF2"
        case .values: return "FF375F"
        case .dreams: return "FFD60A"
        case .fun: return "32D74B"
        case .deep: return "0A84FF"
        case .couples: return "FF6482"
        }
    }
}

enum ConversationDepth: String, Codable, CaseIterable {
    case light = "Light"
    case medium = "Medium"
    case deep = "Deep"

    var emoji: String {
        switch self {
        case .light: return "sun.max"
        case .medium: return "cloud.sun"
        case .deep: return "moon.stars"
        }
    }

    var colorHex: String {
        switch self {
        case .light: return "FFD60A"
        case .medium: return "FF9F0A"
        case .deep: return "BF5AF2"
        }
    }

    var description: String {
        switch self {
        case .light: return "Fun & casual"
        case .medium: return "Personal but comfortable"
        case .deep: return "Meaningful connection"
        }
    }
}

@Model
final class Topic {
    @Attribute(.unique) var id: UUID
    var text: String
    var followUp: String
    var categoryRaw: String
    var depthRaw: String
    var tags: [String]
    var isFavorite: Bool
    var usageCount: Int
    var lastUsed: Date?

    var category: TopicCategory {
        get { TopicCategory(rawValue: categoryRaw) ?? .icebreaker }
        set { categoryRaw = newValue.rawValue }
    }

    var depth: ConversationDepth {
        get { ConversationDepth(rawValue: depthRaw) ?? .light }
        set { depthRaw = newValue.rawValue }
    }

    init(
        text: String,
        followUp: String = "",
        category: TopicCategory = .icebreaker,
        depth: ConversationDepth = .light,
        tags: [String] = []
    ) {
        self.id = UUID()
        self.text = text
        self.followUp = followUp
        self.categoryRaw = category.rawValue
        self.depthRaw = depth.rawValue
        self.tags = tags
        self.isFavorite = false
        self.usageCount = 0
        self.lastUsed = nil
    }
}

@Model
final class DateSession {
    var id: UUID
    var date: Date
    var categoryRaw: String
    var topicIds: [UUID]
    var duration: TimeInterval
    var rating: Int
    var notes: String

    var category: TopicCategory {
        get { TopicCategory(rawValue: categoryRaw) ?? .icebreaker }
        set { categoryRaw = newValue.rawValue }
    }

    init(category: TopicCategory) {
        self.id = UUID()
        self.date = Date()
        self.categoryRaw = category.rawValue
        self.topicIds = []
        self.duration = 0
        self.rating = 0
        self.notes = ""
    }
}
