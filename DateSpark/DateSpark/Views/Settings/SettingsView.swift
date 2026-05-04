import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var subscriptionService: SubscriptionService? = nil
    @State private var showPaywall = false
    @State private var showContactSupport = false

    var body: some View {
        NavigationStack {
            List {
                proSection
                generalSection
                supportSection
                legalSection
                aboutSection
            }
            .navigationTitle("Settings")
            .onAppear {
                if subscriptionService == nil {
                    subscriptionService = SubscriptionService()
                }
            }
            .sheet(isPresented: $showPaywall) {
                if let service = subscriptionService {
                    PaywallView(subscriptionService: service)
                }
            }
            .sheet(isPresented: $showContactSupport) {
                ContactSupportView()
            }
        }
    }

    private var proSection: some View {
        Section {
            if let service = subscriptionService, service.isPro {
                Label("DateSpark Premium", systemImage: "crown.fill")
                    .foregroundStyle(.yellow)
            } else {
                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        Label("Upgrade to Premium", systemImage: "sparkles")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
        } header: {
            Text("Subscription")
        }
    }

    private var generalSection: some View {
        Section {
            if let service = subscriptionService {
                Button {
                    Task {
                        await service.restorePurchases()
                    }
                } label: {
                    Label("Restore Purchases", systemImage: "arrow.clockwise")
                }
            }
        } header: {
            Text("General")
        }
    }

    private var supportSection: some View {
        Section {
            Button {
                showContactSupport = true
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }

            Link(destination: URL(string: "https://apps.apple.com/account/subscriptions")!) {
                Label("Manage Subscription", systemImage: "creditcard")
            }
        } header: {
            Text("Support")
        }
    }

    private var legalSection: some View {
        Section {
            Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/DateSpark/privacy.html")!)
            Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/DateSpark/terms.html")!)
            Link("Support Page", destination: URL(string: "https://asunnyboy861.github.io/DateSpark/support.html")!)
        } header: {
            Text("Legal")
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("About")
        }
    }
}

#Preview {
    SettingsView()
}
