import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 48))
                .foregroundColor(Theme.accent)
            Text("Cardholder Miles Pro")
                .font(Theme.titleFont)
            Text("Unlimited programs, expiry alerts, and balance history chart")
                .font(Theme.bodyFont)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if let product = purchases.products.first {
                Button(action: {
                    Task { await purchases.purchase() }
                }) {
                    Text("Unlock for \(product.displayPrice)")
                        .font(Theme.headlineFont)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.accent)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }
                .accessibilityIdentifier("paywallPurchaseButton")
                .padding(.horizontal)
            }

            Button("Restore Purchases") {
                Task { await purchases.restore() }
            }
            .accessibilityIdentifier("restorePurchasesButton")
            .font(Theme.bodyFont)

            Button("Not Now") { dismiss() }
                .accessibilityIdentifier("paywallDismissButton")
                .font(Theme.bodyFont)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Theme.background.ignoresSafeArea())
        .onChange(of: purchases.isPro) { _, newValue in
            if newValue { dismiss() }
        }
    }
}
