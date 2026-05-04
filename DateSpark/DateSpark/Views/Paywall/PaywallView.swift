import StoreKit
import SwiftUI

struct PaywallView: View {
    let subscriptionService: SubscriptionService
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: Plan = .yearly
    @State private var isPurchasing = false

    enum Plan: String, CaseIterable {
        case monthly = "Monthly"
        case yearly = "Yearly"
        case lifetime = "Lifetime"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    headerSection
                    featuresList
                    planSelector
                    subscribeButton
                    restoreButton
                    disclaimer
                }
                .padding()
                .iPadMaxWidth()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("DateSpark Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundStyle(.yellow)

            Text("Unlock Your Full Dating Potential")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text("Get AI-powered topics, unlimited favorites, and more")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private var featuresList: some View {
        VStack(spacing: 16) {
            FeatureRow(icon: "sparkles", title: "AI Topic Generation", subtitle: "Custom questions for your unique situation")
            FeatureRow(icon: "heart.circle", title: "Unlimited Favorites", subtitle: "Save every topic you love")
            FeatureRow(icon: "chart.bar", title: "Date Insights", subtitle: "Track your conversation journey")
            FeatureRow(icon: "widget.small", title: "Home Screen Widget", subtitle: "Quick topic before your date")
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
    }

    private var planSelector: some View {
        VStack(spacing: 12) {
            ForEach(Plan.allCases, id: \.self) { plan in
                PlanCard(
                    plan: plan,
                    isSelected: selectedPlan == plan,
                    price: priceForPlan(plan),
                    savings: savingsForPlan(plan),
                    action: {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedPlan = plan
                        }
                    }
                )
            }
        }
    }

    private var subscribeButton: some View {
        Button {
            Task {
                isPurchasing = true
                let product = productForPlan(selectedPlan)
                if let product = product {
                    let success = await subscriptionService.purchase(product)
                    if success {
                        dismiss()
                    }
                }
                isPurchasing = false
            }
        } label: {
            if isPurchasing {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Text("Subscribe with 3-Day Free Trial")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(hex: "FF9F0A"))
        .disabled(isPurchasing)
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task {
                await subscriptionService.restorePurchases()
                if subscriptionService.isPro {
                    dismiss()
                }
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }

    private var disclaimer: some View {
        VStack(spacing: 4) {
            Text("Payment will be charged to your Apple ID account at confirmation of purchase.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
            Text("Subscription automatically renews unless cancelled at least 24 hours before the end of the current period.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 20)
    }

    private func priceForPlan(_ plan: Plan) -> String {
        switch plan {
        case .monthly: return subscriptionService.monthlyPrice + "/month"
        case .yearly: return subscriptionService.yearlyPrice + "/year"
        case .lifetime: return subscriptionService.lifetimePrice + " once"
        }
    }

    private func savingsForPlan(_ plan: Plan) -> String? {
        switch plan {
        case .monthly: return nil
        case .yearly: return "Save 58%"
        case .lifetime: return "Best value"
        }
    }

    private func productForPlan(_ plan: Plan) -> Product? {
        switch plan {
        case .monthly: return subscriptionService.monthlyProduct
        case .yearly: return subscriptionService.yearlyProduct
        case .lifetime: return subscriptionService.lifetimeProduct
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color(hex: "FF9F0A"))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct PlanCard: View {
    let plan: PaywallView.Plan
    let isSelected: Bool
    let price: String
    let savings: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(plan.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        if let savings {
                            Text(savings)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color(hex: "FF9F0A").opacity(0.15), in: Capsule())
                                .foregroundStyle(Color(hex: "FF9F0A"))
                        }
                    }
                    Text(price)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? Color(hex: "FF9F0A") : .secondary)
            }
            .padding()
            .background(
                isSelected ? Color(hex: "FF9F0A").opacity(0.08) : Color(.systemBackground),
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "FF9F0A") : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PaywallView(subscriptionService: SubscriptionService())
}
