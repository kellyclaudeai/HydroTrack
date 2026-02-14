import SwiftUI

struct FunFactView: View {
    let fact: String
    
    var body: some View {
        Text(fact)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Theme.radiusM)
                    .fill(Theme.primaryBlue)
                    .shadow(radius: 10)
            )
            .padding(.horizontal, Theme.spacingL)
            .padding(.top, Theme.spacingXL)
    }
}

#Preview {
    FunFactView(fact: "Your brain is 73% water! 🧠")
}
