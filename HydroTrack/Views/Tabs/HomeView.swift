import SwiftUI

struct HomeView: View {
    @EnvironmentObject var waterViewModel: WaterViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    @State private var showingCustomAmount = false
    @State private var showingCelebration = false
    @State private var tripleClickCount = 0
    @State private var showingFunFact = false
    @State private var currentFact = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingL) {
                    // Water vessel
                    WaterVesselView(
                        current: waterViewModel.totalToday,
                        goal: settingsViewModel.userProfile.dailyGoalOz
                    )
                    .frame(height: 300)
                    .onTapGesture(count: 3) {
                        // Easter egg: triple tap for fun fact
                        showHydrationFact()
                    }
                    
                    // Progress text
                    VStack(spacing: Theme.spacingS) {
                        if waterViewModel.totalToday >= settingsViewModel.userProfile.dailyGoalOz {
                            Text("Goal complete! 🎉")
                                .font(.title2.bold())
                                .foregroundColor(Theme.accentGreen)
                        } else {
                            Text("\(Int(waterViewModel.totalToday)) oz logged • \(Int(waterViewModel.remainingAmount(goal: settingsViewModel.userProfile.dailyGoalOz))) oz to go")
                                .font(.headline)
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        if waterViewModel.currentStreak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                Text("\(waterViewModel.currentStreak) day streak")
                                    .font(.subheadline)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                    }
                    
                    // Quick log buttons
                    VStack(spacing: Theme.spacingM) {
                        HStack(spacing: Theme.spacingM) {
                            ForEach(Constants.quickLogAmounts, id: \.self) { amount in
                                QuickLogButton(amount: amount) {
                                    logWater(amount: amount)
                                }
                            }
                        }
                        
                        Button {
                            showingCustomAmount = true
                            HapticManager.impact(.light)
                        } label: {
                            Text("Custom Amount")
                                .font(.subheadline)
                                .foregroundColor(Theme.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(Theme.radiusM)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.radiusM)
                                        .stroke(Theme.primaryBlue, lineWidth: 2)
                                )
                        }
                    }
                    .padding(.horizontal, Theme.spacingL)
                    
                    // Today's history
                    if !waterViewModel.todayEntries.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            Text("Today's History")
                                .font(.headline)
                                .padding(.horizontal, Theme.spacingL)
                            
                            ForEach(waterViewModel.todayEntries) { entry in
                                HistoryEntryRow(entry: entry)
                                    .padding(.horizontal, Theme.spacingL)
                            }
                        }
                    } else {
                        EmptyStateView()
                            .padding(.top, Theme.spacingXL)
                    }
                }
                .padding(.top, Theme.spacingL)
            }
            .background(Theme.backgroundLight)
            .navigationTitle("HydroTrack")
            .sheet(isPresented: $showingCustomAmount) {
                CustomAmountSheet { amount in
                    logWater(amount: amount)
                }
            }
            .overlay(
                Group {
                    if showingCelebration {
                        CelebrationView()
                            .transition(.scale.combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showingCelebration = false
                                    }
                                }
                            }
                    }
                }
            )
            .overlay(
                Group {
                    if showingFunFact {
                        FunFactView(fact: currentFact)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showingFunFact = false
                                    }
                                }
                            }
                    }
                }
                , alignment: .top
            )
        }
        .onChange(of: waterViewModel.totalToday) { _, newValue in
            if newValue >= settingsViewModel.userProfile.dailyGoalOz && !showingCelebration {
                withAnimation {
                    showingCelebration = true
                }
            }
        }
    }
    
    private func logWater(amount: Double) {
        waterViewModel.addEntry(amount: amount)
        healthKitManager.saveWaterIntake(amount: amount)
    }
    
    private func showHydrationFact() {
        currentFact = Constants.hydrationFacts.randomElement() ?? ""
        withAnimation {
            showingFunFact = true
        }
        HapticManager.impact(.light)
    }
}

#Preview {
    HomeView()
        .environmentObject(WaterViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(HealthKitManager())
}
