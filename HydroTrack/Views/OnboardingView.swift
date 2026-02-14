import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var weight: String = "150"
    @State private var selectedActivity: ActivityLevel = .moderate
    @State private var showingGoal = false
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color(hex: "0A7AFF"), Color(hex: "5AC8FA")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if showingGoal {
                goalScreen
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
            } else {
                welcomeScreen
                    .transition(.opacity)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showingGoal)
    }
    
    var welcomeScreen: some View {
        VStack(spacing: Theme.spacingXL) {
            Spacer()
            
            // App icon
            Image(systemName: "drop.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.white)
                .shadow(radius: 10)
            
            VStack(spacing: Theme.spacingS) {
                Text("Welcome to HydroTrack")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Let's personalize your hydration goal")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // Input fields
            VStack(spacing: Theme.spacingL) {
                VStack(alignment: .leading, spacing: Theme.spacingS) {
                    Text("Weight (lbs)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("150", text: $weight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                }
                
                VStack(alignment: .leading, spacing: Theme.spacingS) {
                    Text("Activity Level")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    VStack(spacing: Theme.spacingS) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Button {
                                selectedActivity = level
                                HapticManager.selection()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(level.rawValue)
                                            .font(.headline)
                                        Text(level.description)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    if selectedActivity == level {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Theme.accentGreen)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(Theme.radiusM)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, Theme.spacingL)
            
            Spacer()
            
            // Continue button
            Button {
                if let weightValue = Double(weight) {
                    settingsViewModel.userProfile.weight = weightValue
                    settingsViewModel.userProfile.activityLevel = selectedActivity
                    HapticManager.impact(.medium)
                    withAnimation {
                        showingGoal = true
                    }
                }
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(Theme.primaryBlue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(Theme.radiusM)
            }
            .padding(.horizontal, Theme.spacingL)
            .padding(.bottom, Theme.spacingL)
        }
    }
    
    var goalScreen: some View {
        VStack(spacing: Theme.spacingXL) {
            Spacer()
            
            // Water vessel preview
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 200, height: 200)
                
                Image(systemName: "drop.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: Theme.spacingS) {
                Text("Your daily goal:")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("\(Int(settingsViewModel.userProfile.dailyGoalOz)) oz")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Adjust anytime in Settings")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Text("Tap below to log your first drink →")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
                .padding()
            
            // Quick log buttons preview
            HStack(spacing: Theme.spacingM) {
                ForEach(Constants.quickLogAmounts, id: \.self) { amount in
                    Button {
                        // Complete onboarding
                        settingsViewModel.completeOnboarding()
                        HapticManager.success()
                    } label: {
                        Text("\(Int(amount)) oz")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 90, height: 90)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(Theme.radiusM)
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.radiusM)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                }
            }
            .padding(.horizontal, Theme.spacingL)
            .padding(.bottom, Theme.spacingXL)
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(SettingsViewModel())
}
