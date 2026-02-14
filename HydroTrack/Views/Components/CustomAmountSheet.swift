import SwiftUI

struct CustomAmountSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var amount: String = ""
    
    let onLog: (Double) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingL) {
                // Amount display
                VStack(spacing: Theme.spacingS) {
                    Text(amount.isEmpty ? "0" : amount)
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.primaryBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.backgroundLight)
                        .cornerRadius(Theme.radiusM)
                    
                    Text("ounces")
                        .font(.headline)
                        .foregroundColor(Theme.textSecondary)
                }
                .padding(.top, Theme.spacingL)
                
                // Common presets
                VStack(alignment: .leading, spacing: Theme.spacingM) {
                    Text("Common Containers")
                        .font(.headline)
                        .foregroundColor(Theme.textSecondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.spacingM) {
                            ForEach(Constants.commonContainers, id: \.0) { container in
                                Button {
                                    amount = String(format: "%.1f", container.1)
                                    HapticManager.impact(.light)
                                } label: {
                                    VStack {
                                        Text(container.0)
                                            .font(.caption)
                                        Text("\(String(format: "%.1f", container.1)) oz")
                                            .font(.caption2)
                                            .foregroundColor(Theme.textSecondary)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(Theme.radiusS)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                
                // Number pad
                VStack(spacing: Theme.spacingM) {
                    ForEach(0..<3) { row in
                        HStack(spacing: Theme.spacingM) {
                            ForEach(1...3, id: \.self) { col in
                                let number = row * 3 + col
                                NumberButton(number: "\(number)") {
                                    amount += "\(number)"
                                    HapticManager.selection()
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: Theme.spacingM) {
                        NumberButton(number: ".") {
                            if !amount.contains(".") {
                                amount += "."
                                HapticManager.selection()
                            }
                        }
                        
                        NumberButton(number: "0") {
                            amount += "0"
                            HapticManager.selection()
                        }
                        
                        Button {
                            if !amount.isEmpty {
                                amount.removeLast()
                                HapticManager.selection()
                            }
                        } label: {
                            Image(systemName: "delete.left")
                                .font(.title2)
                                .foregroundColor(Theme.textPrimary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Theme.backgroundLight)
                                .cornerRadius(Theme.radiusS)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Log button
                Button {
                    if let value = Double(amount), value > 0, value <= 128 {
                        onLog(value)
                        dismiss()
                    } else {
                        HapticManager.error()
                    }
                } label: {
                    Text("Log Water")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.primaryBlue)
                        .cornerRadius(Theme.radiusM)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .disabled(amount.isEmpty || Double(amount) == nil)
            }
            .padding()
            .navigationTitle("Custom Amount")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct NumberButton: View {
    let number: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(number)
                .font(.title)
                .foregroundColor(Theme.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Theme.backgroundLight)
                .cornerRadius(Theme.radiusS)
        }
    }
}

#Preview {
    CustomAmountSheet { amount in
        print("Logged: \(amount)")
    }
}
