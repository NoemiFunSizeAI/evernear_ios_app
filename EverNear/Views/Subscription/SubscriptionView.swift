import SwiftUI

struct SubscriptionView: View {
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var selectedInterval: SubscriptionInterval = .monthly
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text("Choose Your Plan")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Interval Picker
                    Picker("Interval", selection: $selectedInterval) {
                        Text("Monthly").tag(SubscriptionInterval.monthly)
                        Text("Yearly").tag(SubscriptionInterval.yearly)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Subscription Tiers
                    ForEach(SubscriptionTier.allCases, id: \.self) { tier in
                        SubscriptionCard(
                            tier: tier,
                            interval: selectedInterval,
                            isSelected: subscriptionManager.currentTier == tier
                        )
                        .padding(.horizontal)
                    }
                    
                    // Restore Purchases Button
                    Button(action: {
                        Task {
                            try? await subscriptionManager.restorePurchases()
                        }
                    }) {
                        Text("Restore Purchases")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Terms and Privacy
                    VStack(spacing: 8) {
                        Text("By subscribing, you agree to our")
                        HStack {
                            Link("Terms of Service", destination: URL(string: "https://evernear.app/terms")!)
                            Text("and")
                            Link("Privacy Policy", destination: URL(string: "https://evernear.app/privacy")!)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                }
            }
            .navigationBarItems(trailing: Button("Done") { dismiss() })
        }
    }
}

struct SubscriptionCard: View {
    let tier: SubscriptionTier
    let interval: SubscriptionInterval
    let isSelected: Bool
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    
    var price: Decimal {
        interval == .monthly ? tier.monthlyPrice : tier.yearlyPrice
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Text(tier.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                if tier != .free {
                    VStack(alignment: .trailing) {
                        Text("$\\(price, specifier: "%.2f")/\(interval == .monthly ? "month" : "year")")
                            .font(.title3)
                            .fontWeight(.semibold)
                        if interval == .yearly {
                            Text("Save 17%")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            
            // Features
            VStack(alignment: .leading, spacing: 8) {
                ForEach(tier.features, id: \\.self) { feature in
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(feature)
                            .font(.subheadline)
                    }
                }
            }
            
            // Subscribe Button
            if tier != .free {
                Button(action: {
                    Task {
                        try? await subscriptionManager.purchase(tier, interval: interval)
                    }
                }) {
                    Text(isSelected ? "Current Plan" : "Subscribe")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSelected ? Color.gray : Color.accentColor)
                        .cornerRadius(12)
                }
                .disabled(isSelected)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}
