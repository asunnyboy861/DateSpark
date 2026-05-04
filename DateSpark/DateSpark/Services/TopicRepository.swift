import SwiftData
import Foundation

@Observable
final class TopicRepository {
    var isLoading = false

    func seedTopicsIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Topic>(predicate: nil)
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        isLoading = true
        defer { isLoading = false }

        let topics = Self.buildSeedTopics()
        for topic in topics {
            context.insert(topic)
        }
        try? context.save()
    }

    func fetchTopics(
        category: TopicCategory,
        depth: ConversationDepth,
        context: ModelContext
    ) -> [Topic] {
        let descriptor = FetchDescriptor<Topic>(
            predicate: #Predicate<Topic> {
                $0.categoryRaw == category.rawValue && $0.depthRaw == depth.rawValue
            }
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchFavorites(context: ModelContext) -> [Topic] {
        let descriptor = FetchDescriptor<Topic>(
            predicate: #Predicate<Topic> { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.lastUsed, order: .reverse)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func toggleFavorite(_ topic: Topic, context: ModelContext) {
        topic.isFavorite.toggle()
        try? context.save()
    }

    func markAsUsed(_ topic: Topic, context: ModelContext) {
        topic.usageCount += 1
        topic.lastUsed = Date()
        try? context.save()
    }

    static func buildSeedTopics() -> [Topic] {
        var topics: [Topic] = []

        let icebreakerLight: [(String, String)] = [
            ("What's the best thing that happened to you this week?", "If you could relive that moment, would you change anything?"),
            ("What's a small thing that made you smile today?", "Do you think it's the little things that matter most?"),
            ("If you could instantly become an expert in anything, what would it be?", "What's holding you back from trying it right now?"),
            ("What's the most spontaneous thing you've ever done?", "Would you do it again?"),
            ("What's your go-to comfort food?", "Is there a memory attached to that?"),
            ("Do you have any hidden talents?", "How did you discover that talent?"),
            ("What's the best trip you've ever taken?", "What made it so special?"),
            ("If you could live anywhere in the world for a year, where would you go?", "What would your daily routine look like there?"),
            ("What's the last thing that made you laugh out loud?", "Do you think humor is underrated?"),
            ("What's your favorite way to spend a lazy Sunday?", "Do you prefer being productive or relaxing on weekends?"),
            ("If you could have dinner with anyone, alive or dead, who would it be?", "What would you ask them?"),
            ("What's something you've always wanted to learn but haven't yet?", "What's stopping you?"),
            ("What's the most interesting documentary you've watched recently?", "Did it change how you think about anything?"),
            ("Do you collect anything?", "What started that collection?"),
            ("What's your earliest childhood memory?", "Do you think memories shape who we become?"),
        ]
        for (text, followUp) in icebreakerLight {
            topics.append(Topic(text: text, followUp: followUp, category: .icebreaker, depth: .light))
        }

        let icebreakerMedium: [(String, String)] = [
            ("What's something people usually get wrong about you?", "How does that make you feel?"),
            ("What's a belief you held strongly but changed your mind about?", "What caused the shift?"),
            ("When do you feel most like yourself?", "Is that something you get to do often?"),
            ("What's the bravest thing you've ever done?", "Would you make the same choice today?"),
            ("What's a compliment you've received that really stuck with you?", "Why do you think it resonated?"),
            ("What's something you're quietly proud of?", "Why don't you share that more?"),
            ("If you could send a message to your younger self, what would you say?", "Do you think they'd listen?"),
            ("What's the most meaningful gift you've ever received?", "What made it special?"),
        ]
        for (text, followUp) in icebreakerMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .icebreaker, depth: .medium))
        }

        let icebreakerDeep: [(String, String)] = [
            ("What's a fear you've overcome, and how did you do it?", "Did overcoming it change you?"),
            ("What's the hardest lesson life has taught you so far?", "Do you think you had to learn it the hard way?"),
            ("What does vulnerability mean to you?", "Is it something you find easy or difficult?"),
            ("What's something you've never told anyone?", "What made you keep it to yourself?"),
        ]
        for (text, followUp) in icebreakerDeep {
            topics.append(Topic(text: text, followUp: followUp, category: .icebreaker, depth: .deep))
        }

        let travelLight: [(String, String)] = [
            ("What's the most beautiful place you've ever been?", "What made it so beautiful to you?"),
            ("Are you a beach person or a mountain person?", "What does that say about your personality?"),
            ("What's the strangest food you've tried while traveling?", "Would you eat it again?"),
            ("Do you prefer planned trips or spontaneous adventures?", "What's the best trip you didn't plan?"),
            ("What's your dream destination?", "What's keeping you from going?"),
            ("Have you ever gotten lost while traveling?", "Did it lead to something unexpected?"),
            ("What's the longest flight you've been on?", "How do you pass the time?"),
            ("Do you prefer traveling alone or with someone?", "What's the best part of each?"),
        ]
        for (text, followUp) in travelLight {
            topics.append(Topic(text: text, followUp: followUp, category: .travel, depth: .light))
        }

        let travelMedium: [(String, String)] = [
            ("Has traveling ever changed your perspective on something?", "What specifically shifted?"),
            ("What's a place that felt like home even though you'd never been there?", "Why do you think it resonated?"),
            ("What's the most meaningful souvenir you've brought back?", "What's the story behind it?"),
            ("If you could relive one travel memory, which would it be?", "What made it so perfect?"),
        ]
        for (text, followUp) in travelMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .travel, depth: .medium))
        }

        let travelDeep: [(String, String)] = [
            ("How has travel shaped who you are today?", "Was there a specific moment of transformation?"),
            ("What's a place that challenged your worldview?", "How did you process that?"),
        ]
        for (text, followUp) in travelDeep {
            topics.append(Topic(text: text, followUp: followUp, category: .travel, depth: .deep))
        }

        let foodLight: [(String, String)] = [
            ("What's your ultimate comfort meal?", "Who makes it best?"),
            ("If you could only eat one cuisine for the rest of your life, what would it be?", "What's your favorite dish from that cuisine?"),
            ("Are you a coffee or tea person?", "What's your go-to order?"),
            ("What's the weirdest food combination you secretly love?", "How did you discover it?"),
            ("What's your favorite restaurant in the city?", "What do you usually order there?"),
            ("Do you enjoy cooking?", "What's your signature dish?"),
            ("What's the best meal you've ever had?", "What made it so memorable?"),
            ("Breakfast: sweet or savory?", "What's your ideal breakfast?"),
        ]
        for (text, followUp) in foodLight {
            topics.append(Topic(text: text, followUp: followUp, category: .food, depth: .light))
        }

        let foodMedium: [(String, String)] = [
            ("Is there a food that reminds you of home?", "What memories does it bring back?"),
            ("What's a food tradition your family has?", "Do you plan to pass it on?"),
            ("Has a meal ever changed your life?", "What happened?"),
        ]
        for (text, followUp) in foodMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .food, depth: .medium))
        }

        let entertainmentLight: [(String, String)] = [
            ("What movie can you watch over and over without getting bored?", "What keeps drawing you back?"),
            ("What's the best concert you've ever been to?", "What made it unforgettable?"),
            ("Are you into podcasts? What's your favorite?", "What do you love about it?"),
            ("What's a TV show you think everyone should watch?", "What makes it so good?"),
            ("What kind of music do you listen to when you need to focus?", "Does it help or distract?"),
            ("What's the last book that really stuck with you?", "What about it resonated?"),
            ("Do you play any video games?", "What's your all-time favorite?"),
            ("What's a movie that made you cry?", "Was it the story or something personal?"),
        ]
        for (text, followUp) in entertainmentLight {
            topics.append(Topic(text: text, followUp: followUp, category: .entertainment, depth: .light))
        }

        let entertainmentMedium: [(String, String)] = [
            ("Has a song ever perfectly captured how you were feeling?", "What was the song and the feeling?"),
            ("What's a piece of art that moved you?", "Why do you think it affected you?"),
            ("Is there a fictional character you relate to?", "In what way?"),
        ]
        for (text, followUp) in entertainmentMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .entertainment, depth: .medium))
        }

        let valuesLight: [(String, String)] = [
            ("What's one rule you try to live by?", "Has it ever been tested?"),
            ("Do you think people can truly change?", "Have you seen it happen?"),
            ("What's more important: honesty or kindness?", "Can they ever conflict?"),
            ("What's a hill you're willing to die on?", "Why is it so important to you?"),
        ]
        for (text, followUp) in valuesLight {
            topics.append(Topic(text: text, followUp: followUp, category: .values, depth: .light))
        }

        let valuesMedium: [(String, String)] = [
            ("What's a value you inherited from your parents?", "Do you still hold it?"),
            ("When was the last time you stood up for something you believe in?", "What happened?"),
            ("What's something you used to value but don't anymore?", "What changed?"),
            ("How do you define success?", "Has that definition changed over time?"),
        ]
        for (text, followUp) in valuesMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .values, depth: .medium))
        }

        let valuesDeep: [(String, String)] = [
            ("What's the most difficult moral decision you've faced?", "How did you decide?"),
            ("What do you think happens after we die?", "Does that belief affect how you live?"),
            ("What's a truth about yourself that took you a long time to accept?", "How did acceptance feel?"),
        ]
        for (text, followUp) in valuesDeep {
            topics.append(Topic(text: text, followUp: followUp, category: .values, depth: .deep))
        }

        let dreamsLight: [(String, String)] = [
            ("What's something you want to accomplish this year?", "What's the first step?"),
            ("If money were no object, what would you do with your days?", "What's stopping you from doing some version of that now?"),
            ("What's a skill you've always wanted to master?", "Have you started learning it?"),
            ("What does your ideal day look like?", "How close is your current life to that?"),
            ("What's a dream you've put on hold?", "Is it still something you want?"),
        ]
        for (text, followUp) in dreamsLight {
            topics.append(Topic(text: text, followUp: followUp, category: .dreams, depth: .light))
        }

        let dreamsMedium: [(String, String)] = [
            ("What's the biggest risk you've taken for a dream?", "Was it worth it?"),
            ("Do you think dreams should be practical?", "What if they're not?"),
            ("What would you do if you knew you couldn't fail?", "What's the real fear behind not trying?"),
        ]
        for (text, followUp) in dreamsMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .dreams, depth: .medium))
        }

        let dreamsDeep: [(String, String)] = [
            ("What legacy do you want to leave behind?", "Are you working toward that?"),
            ("What's a dream you've given up on? Do you regret it?", "Is there a way to revisit it?"),
        ]
        for (text, followUp) in dreamsDeep {
            topics.append(Topic(text: text, followUp: followUp, category: .dreams, depth: .deep))
        }

        let funLight: [(String, String)] = [
            ("Would you rather have the ability to fly or be invisible?", "What would you do first?"),
            ("What's the most embarrassing song on your playlist?", "Do you secretly love it?"),
            ("If you were a superhero, what would your power be?", "What would your weakness be?"),
            ("What's the worst advice you've ever received?", "Did you follow it?"),
            ("If you could time travel, would you go to the past or future?", "What era would you visit?"),
            ("What's your guilty pleasure TV show?", "Why do you love it?"),
            ("Would you rather always be 10 minutes late or 20 minutes early?", "How would that change your life?"),
            ("What's the funniest thing that's happened to you recently?", "Did you laugh about it right away?"),
        ]
        for (text, followUp) in funLight {
            topics.append(Topic(text: text, followUp: followUp, category: .fun, depth: .light))
        }

        let funMedium: [(String, String)] = [
            ("What's the most ridiculous thing you've done for love?", "Would you do it again?"),
            ("If your life had a theme song, what would it be?", "Why that song?"),
        ]
        for (text, followUp) in funMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .fun, depth: .medium))
        }

        let deepLight: [(String, String)] = [
            ("What makes you feel truly alive?", "How often do you get to experience that?"),
            ("What's a moment you wish you could freeze in time?", "What made it so perfect?"),
            ("Who in your life understands you best?", "What makes that connection special?"),
            ("What's something you've never said out loud?", "What would happen if you did?"),
        ]
        for (text, followUp) in deepLight {
            topics.append(Topic(text: text, followUp: followUp, category: .deep, depth: .light))
        }

        let deepMedium: [(String, String)] = [
            ("What's the most important thing you've learned about yourself?", "How did you learn it?"),
            ("When do you feel most disconnected from the world?", "What brings you back?"),
            ("What's a conversation that changed your life?", "What was said?"),
            ("What do you need more of in your life right now?", "What's one step toward that?"),
        ]
        for (text, followUp) in deepMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .deep, depth: .medium))
        }

        let deepDeep: [(String, String)] = [
            ("What's the thing you're most afraid of losing?", "How does that fear shape your choices?"),
            ("What does love mean to you?", "Has your definition changed over time?"),
            ("What's the most vulnerable you've ever allowed yourself to be?", "What was the outcome?"),
            ("If today were your last day, what would you regret not doing?", "What's stopping you from starting now?"),
        ]
        for (text, followUp) in deepDeep {
            topics.append(Topic(text: text, followUp: followUp, category: .deep, depth: .deep))
        }

        let couplesLight: [(String, String)] = [
            ("What's your favorite memory of us together?", "What made that moment special?"),
            ("What's something new you'd like us to try together?", "What's exciting about that?"),
            ("What's a small thing I do that makes you smile?", "Do you notice it every time?"),
            ("What's your favorite thing about our relationship?", "Has it always been that way?"),
            ("If we could go anywhere together tomorrow, where would we go?", "What would we do there?"),
            ("What's something you admire about me?", "When did you first notice it?"),
        ]
        for (text, followUp) in couplesLight {
            topics.append(Topic(text: text, followUp: followUp, category: .couples, depth: .light))
        }

        let couplesMedium: [(String, String)] = [
            ("What's something you've been wanting to tell me?", "How can I support you with that?"),
            ("What's a challenge we've overcome together?", "What did it teach us?"),
            ("How have we grown since we first met?", "What surprised you most?"),
            ("What's something we don't talk about enough?", "Should we change that?"),
        ]
        for (text, followUp) in couplesMedium {
            topics.append(Topic(text: text, followUp: followUp, category: .couples, depth: .medium))
        }

        let couplesDeep: [(String, String)] = [
            ("What does our future look like to you?", "Does it excite you or scare you?"),
            ("What's the hardest thing about being with me?", "How do we work through that?"),
            ("What do you need from me that you're not getting?", "How can I show up better for you?"),
        ]
        for (text, followUp) in couplesDeep {
            topics.append(Topic(text: text, followUp: followUp, category: .couples, depth: .deep))
        }

        return topics
    }
}
