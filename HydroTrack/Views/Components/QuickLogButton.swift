import SwiftUI

struct QuickLogButton: View {
    let amount: Double
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            HapticManager.impact(.medium)
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    isPressed = false
                }
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: "drop.fill")
                    .font(.title2)
                
                Text("\(Int(amount))")
                    .font(.title.bold())
                
                Text("oz")
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            .foregroundColor(Theme.primaryBlue)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.white)
            .cornerRadius(Theme.radiusM)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusM)
                    .stroke(Theme.primaryBlue, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
            .scaleEffect(isPressed ? 0.92 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        QuickLogButton(amount: 8) { }
        QuickLogButton(amount: 16) { }
        QuickLogButton(amount: 24) { }
    }
    .padding()
}
