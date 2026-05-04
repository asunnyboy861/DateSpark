# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "订阅" / "会员" / "premium" / "Pro" keywords detected -> In-App Purchase required
- "AI生成" / "OpenAI" / "Firebase" keywords detected -> Outgoing network connections needed
- No iCloud/sync keywords detected -> Local only storage
- No camera/photo keywords detected
- No location/health keywords detected
- No push notification keywords detected (optional future: daily topic notification)

## Auto-Configured Capabilities
| Capability | Status | Method |
|------------|--------|--------|
| In-App Purchase | ✅ Configured | StoreKit 2 in code |
| Outgoing Network Connections | ✅ Configured | Info.plist NSAppTransportSecurity |

## Manual Configuration Required
| Capability | Status | Steps |
|------------|--------|-------|
| In-App Purchase (App Store Connect) | ⏳ Pending | Create subscription group and products in App Store Connect before submission |

## No Configuration Needed
- iCloud / CloudKit (local only storage)
- Push Notifications (not in MVP)
- HealthKit (not applicable)
- Camera / Photo Library (not applicable)
- Location Services (not applicable)
- Apple Watch (not in MVP)
- Siri (not applicable)
- Background Modes (not in MVP)

## Verification
- Build succeeded after configuration: ✅
- All entitlements correct: ✅
