import StoreKit
import Foundation

@Observable
final class SubscriptionService {
    var isPro = false
    var monthlyProduct: Product?
    var yearlyProduct: Product?
    var lifetimeProduct: Product?
    var products: [Product] = []
    var isLoading = false

    private var transactionListener: Task<Void, Never>?

    static let monthlyID = "com.zzoutuo.DateSpark.monthly"
    static let yearlyID = "com.zzoutuo.DateSpark.yearly"
    static let lifetimeID = "com.zzoutuo.DateSpark.lifetime"

    init() {
        transactionListener = Task {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await updateProStatus()
                    await transaction.finish()
                }
            }
        }
        Task {
            await loadProducts()
            await updateProStatus()
        }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            products = try await Product.products(for: [Self.monthlyID, Self.yearlyID, Self.lifetimeID])
            monthlyProduct = products.first { $0.id == Self.monthlyID }
            yearlyProduct = products.first { $0.id == Self.yearlyID }
            lifetimeProduct = products.first { $0.id == Self.lifetimeID }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await updateProStatus()
                    await transaction.finish()
                    return true
                }
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        return false
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateProStatus()
        } catch {
            print("Restore failed: \(error)")
        }
    }

    private func updateProStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if [Self.monthlyID, Self.yearlyID, Self.lifetimeID].contains(transaction.productID) {
                    isPro = transaction.revocationDate == nil
                    return
                }
            }
        }
        isPro = false
    }

    var monthlyPrice: String {
        monthlyProduct?.displayPrice ?? "$2.99"
    }

    var yearlyPrice: String {
        yearlyProduct?.displayPrice ?? "$14.99"
    }

    var lifetimePrice: String {
        lifetimeProduct?.displayPrice ?? "$29.99"
    }
}
