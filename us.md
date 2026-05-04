# DateSpark - iOS Development Guide

## Executive Summary

DateSpark is a face-to-face date conversation starter app designed for the US market. It solves the universal problem of awkward silence on dates by providing 200+ curated conversation topics organized by category and depth level. Unlike competitors (Rizz, PlugAI) that focus on online chat assistance, DateSpark is the only app purpose-built for in-person dating scenarios with a card-based, gesture-first interface.

**Target Audience**: Introverts, socially anxious daters, new couples, and long-term partners seeking deeper connection in the US market.

**Key Differentiators**:
- Only app focused on face-to-face dating (not online chat)
- 100% local privacy - no data upload, works offline
- Progressive depth system (Light -> Medium -> Deep)
- Card-based interaction with 3D flip animation and swipe gestures
- Transparent pricing with no subscription traps

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Rizz | 4.8 rating, 23K reviews, established brand | Online chat only, requires screenshot upload, $7/week, unnatural AI replies, subscription traps | Face-to-face focus, local privacy, natural topics, transparent pricing |
| PlugAI | Available on iOS | $4.99/week, sleazy replies, Google Play 2.6 rating, may violate dating app TOS | Genuine conversation starters, not chat replacement |
| MeetQ | Free, icebreaker questions, gamification | Generic questions, no depth levels, no date-specific categories, no AI | Date-specific categories, progressive depth, optional AI |
| We2 | AI-powered couple questions | Couples only, not for first dates | Covers all date stages from first date to long-term |
| Party Qs | 2150 questions, free | No AI, no personalization, no depth control | AI personalization, depth system, smart recommendations |

## Apple Design Guidelines Compliance

- **Haptic Feedback**: Use UIImpactFeedbackGenerator for card flip and swipe actions
- **Dynamic Type**: Support up to 2x font scaling, test with accessibility sizes
- **VoiceOver**: All card content must be accessible, provide meaningful labels for gestures
- **Reduce Motion**: Simplify 3D flip animation to cross-dissolve when enabled
- **Dark Mode**: Full support with warm color palette adaptation
- **SF Symbols**: Use system symbols for all icons (heart, arrow, sparkles)
- **Minimum Touch Target**: 44x44pt for all interactive elements
- **Liquid Glass Ready**: Use standard SwiftUI components for future iOS 26 compatibility

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), SwiftData for persistence
- **Architecture**: MVVM + Repository pattern
- **Data**: SwiftData (iOS 17+), local JSON seed database
- **Networking**: URLSession (optional AI feature, Firebase Cloud Functions proxy)
- **Payment**: StoreKit 2 for subscription management
- **Animation**: SwiftUI + custom transitions for card flip/swipe
- **Widget**: WidgetKit for date-night quick topic

## Module Structure

```
DateSpark/
├── DateSparkApp.swift
├── Models/
│   ├── Topic.swift
│   ├── TopicCategory.swift
│   ├── ConversationDepth.swift
│   └── DateSession.swift
├── ViewModels/
│   ├── TopicViewModel.swift
│   ├── SessionViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Session/
│   │   ├── SessionView.swift
│   │   └── TopicCardView.swift
│   ├── Favorites/
│   │   └── FavoritesView.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── ContactSupportView.swift
│   └── Paywall/
│       └── PaywallView.swift
├── Services/
│   ├── TopicRepository.swift
│   ├── SubscriptionService.swift
│   └── FeedbackService.swift
├── Resources/
│   └── TopicDatabase.json
└── Extensions/
    ├── Color+Theme.swift
    └── View+Modifiers.swift
```

## Implementation Flow

1. Create data models (Topic, TopicCategory, ConversationDepth, DateSession) with SwiftData
2. Build TopicRepository with JSON seed data loading and SwiftData persistence
3. Create HomeView with category grid picker and depth selector
4. Build SessionView with card container and navigation
5. Implement TopicCardView with 3D flip animation and swipe gesture
6. Add FavoritesView with SwiftData query
7. Create SubscriptionService with StoreKit 2
8. Build PaywallView for Pro upgrade
9. Implement SettingsView with policy links and contact support
10. Add ContactSupportView with feedback backend integration
11. Create TopicDatabase.json with 200+ curated topics
12. Add haptic feedback throughout interactions
13. Ensure iPad layout with maxWidth constraints
14. Test on iPhone XS Max and iPad Pro 13-inch (M4)

## UI/UX Design Specifications

- **Color Scheme**: Warm palette - Light depth (#FFD60A gold), Medium depth (#FF9F0A orange), Deep depth (#BF5AF2 purple)
- **Background**: Warm white (#FAFAF8) for light mode, deep charcoal (#1C1C1E) for dark mode
- **Typography**: SF Pro system font, .title2 for card text, .caption for badges
- **Card Design**: 24pt corner radius, gradient fill based on depth, 70% screen height
- **Layout**: Generous whitespace, centered card, bottom action buttons
- **Animations**: Spring(duration: 0.5, bounce: 0.3) for card flip, easeOut for swipe dismiss
- **Gestures**: Tap to flip card, horizontal drag to swipe/dismiss, vertical drag reserved
- **Tab Bar**: Home (house), Favorites (heart), Settings (gear) - 3 tabs
- **iPad Layout**: Max width 720pt for content, centered with breathing room

## Code Generation Rules

- Use @Observable macro (not ObservableObject) for ViewModels (iOS 17+)
- Use SwiftData @Model for all persistent models
- All SwiftData attributes must be optional or have default values
- Use #Predicate for SwiftData queries
- No third-party dependencies - pure SwiftUI/SwiftData
- No comments in code unless explicitly requested
- Use SF Symbols for all icons
- Implement haptic feedback for all interactive gestures
- Support Dynamic Type with .lineLimit and .minimumScaleFactor
- iPad: Add .frame(maxWidth: 720).frame(maxWidth: .infinity) for ScrollView content

## Build & Deployment Checklist

- [ ] Bundle ID: com.zzoutuo.DateSpark
- [ ] Deployment Target: iOS 17.0
- [ ] Swift Language Version: 5.0
- [ ] App Icon configured in Asset Catalog
- [ ] StoreKit Configuration file for testing IAP
- [ ] Privacy Policy page deployed
- [ ] Support page deployed
- [ ] Terms of Use page deployed (for subscription)
- [ ] Test on iPhone XS Max simulator
- [ ] Test on iPad Pro 13-inch (M4) simulator
- [ ] VoiceOver testing
- [ ] Dynamic Type testing up to 2x
- [ ] Dark mode testing
- [ ] Reduce Motion testing
