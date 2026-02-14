import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: Theme.spacingL) {
            Image(systemName: "drop.circle")
                .font(.system(size: 60))
                .foregroundColor(Theme.primaryBlue.opacity(0.5))
            
            VStack(spacing: Theme.spacingS) {
                Text("Start your day hydrated")
                    .font(.title2.bold())
                    .foregroundColor(Theme.textPrimary)
                
                Text("Tap a size below to log your first drink")
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

#Preview {
    EmptyStateView()
}
