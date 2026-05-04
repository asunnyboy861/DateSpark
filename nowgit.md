# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | DateSpark |
| **Git URL** | git@github.com:asunnyboy861/DateSpark.git |
| **Repo URL** | https://github.com/asunnyboy861/DateSpark |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/DateSpark/ | ✅ Active |
| Support | https://asunnyboy861.github.io/DateSpark/support.html | ✅ Active |
| Privacy Policy | https://asunnyboy861.github.io/DateSpark/privacy.html | ✅ Active |
| Terms of Use | https://asunnyboy861.github.io/DateSpark/terms.html | ✅ Active |

**Note**: Terms of Use required for IAP subscription apps.

## Repository Structure

### Main App Repository
```
DateSpark/
├── DateSpark/                        # iOS App Source Code
│   ├── DateSpark.xcodeproj/          # Xcode Project
│   ├── DateSpark/                    # Swift Source Files
│   │   ├── Views/
│   │   │   ├── Home/HomeView.swift
│   │   │   ├── Session/SessionView.swift
│   │   │   │   └── TopicCardView.swift
│   │   │   ├── Favorites/FavoritesView.swift
│   │   │   ├── Settings/SettingsView.swift
│   │   │   │   └── ContactSupportView.swift
│   │   │   └── Paywall/PaywallView.swift
│   │   ├── Models/Topic.swift
│   │   ├── Services/
│   │   │   ├── TopicRepository.swift
│   │   │   ├── SubscriptionService.swift
│   │   │   └── FeedbackService.swift
│   │   ├── ViewModels/
│   │   │   ├── TopicViewModel.swift
│   │   │   ├── SessionViewModel.swift
│   │   │   └── SettingsViewModel.swift
│   │   ├── Extensions/
│   │   │   ├── Color+Theme.swift
│   │   │   └── View+Modifiers.swift
│   │   └── DateSparkApp.swift
│   └── ...
├── docs/                             # Policy Pages (GitHub Pages)
│   ├── index.html                    # Landing Page
│   ├── support.html                  # Support Page
│   ├── privacy.html                  # Privacy Policy
│   └── terms.html                    # Terms of Use
├── .github/workflows/
│   └── deploy.yml                    # GitHub Pages deployment
├── DateSpark-pic/                    # App Store Screenshots
│   └── iphone/
├── us.md                             # English Development Guide
├── keytext.md                        # App Store Metadata
├── capabilities.md                   # Capabilities Configuration
├── icon.md                           # App Icon Details
├── price.md                          # Pricing Configuration
└── nowgit.md                         # This File
```

## App Store Connect

| Item | Value |
|------|-------|
| **App Name** | DateSpark |
| **Bundle ID** | com.zzoutuo.DateSpark |
| **Primary Category** | Lifestyle |
| **Secondary Category** | Entertainment |
| **Age Rating** | 17+ |
| **Monetization** | Subscription (IAP) |

## Subscription Products

| Product | ID | Price |
|---------|-----|-------|
| Monthly Premium | com.zzoutuo.DateSpark.monthly | $2.99/month |
| Yearly Premium | com.zzoutuo.DateSpark.yearly | $14.99/year |
| Lifetime Access | com.zzoutuo.DateSpark.lifetime | $29.99 |
