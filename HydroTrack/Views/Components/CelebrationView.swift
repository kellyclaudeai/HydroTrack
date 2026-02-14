import SwiftUI

struct CelebrationView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: Theme.spacingL) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.yellow)
                    .scaleEffect(isAnimating ? 1.2 : 0.5)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                
                Text("Goal Complete!")
                    .font(.title.bold())
                    .foregroundColor(.white)
                
                Text("🎉")
                    .font(.system(size: 60))
                    .scaleEffect(isAnimating ? 1.0 : 0.5)
            }
            .padding(Theme.spacingXL)
            .background(
                RoundedRectangle(cornerRadius: Theme.radiusXL)
                    .fill(Theme.accentGreen)
            )
            .shadow(radius: 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                isAnimating = true
            }
            HapticManager.success()
            
            // Second haptic after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                HapticManager.success()
            }
        }
    }
}

#Preview {
    CelebrationView()
}
