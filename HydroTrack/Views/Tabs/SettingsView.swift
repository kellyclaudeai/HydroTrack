import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var waterViewModel: WaterViewModel
    
    @State private var showingResetConfirmation = false
    @State private var tempGoal: Double
    
    init() {
        _tempGoal = State(initialValue: 64)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Daily Goal")
                        Spacer()
                        Text("\(Int(settingsViewModel.userProfile.dailyGoalOz)) oz")
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Slider(
                        value: Binding(
                            get: { settingsViewModel.userProfile.dailyGoalOz },
                            set: { settingsViewModel.userProfile.dailyGoalOz = $0 }
                        ),
                        in: Constants.minGoal...Constants.maxGoal,
                        step: 8
                    )
                    .tint(Theme.primaryBlue)
                    .onChange(of: settingsViewModel.userProfile.dailyGoalOz) { _, _ in
                        HapticManager.selection()
                    }
                    
                    Stepper("Weight: \(Int(settingsViewModel.userProfile.weight)) lbs", value: Binding(
                        get: { settingsViewModel.userProfile.weight },
                        set: { newValue in
                            settingsViewModel.userProfile.weight = newValue
                            // Recalculate goal based on new weight
                            let baseGoal = newValue * settingsViewModel.userProfile.activityLevel.multiplier
                            settingsViewModel.userProfile.dailyGoalOz = max(64, min(baseGoal, 128))
                        }
                    ), in: 80...400, step: 5)
                    
                    Picker("Activity Level", selection: $settingsViewModel.userProfile.activityLevel) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .onChange(of: settingsViewModel.userProfile.activityLevel) { _, newValue in
                        // Recalculate goal based on new activity level
                        let baseGoal = settingsViewModel.userProfile.weight * newValue.multiplier
                        settingsViewModel.userProfile.dailyGoalOz = max(64, min(baseGoal, 128))
                    }
                } header: {
                    Text("Your Goal")
                } footer: {
                    Text("Goal is calculated based on your weight and activity level")
                }
                
                Section {
                    Toggle("Use Metric (mL)", isOn: $settingsViewModel.userProfile.useMetric)
                        .onChange(of: settingsViewModel.userProfile.useMetric) { _, _ in
                            HapticManager.selection()
                        }
                } header: {
                    Text("Units")
                }
                
                Section {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(healthKitManager.isAuthorized ? Theme.accentGreen : Theme.errorRed)
                        
                        Text("Apple Health")
                        
                        Spacer()
                        
                        Text(healthKitManager.isAuthorized ? "Connected" : "Not Connected")
                            .font(.subheadline)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    if !healthKitManager.isAuthorized {
                        Button {
                            healthKitManager.requestAuthorization()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Request Access")
                            }
                        }
                    }
                } header: {
                    Text("Integrations")
                } footer: {
                    Text("Sync your water intake with Apple Health app")
                }
                
                Section {
                    Button(role: .destructive) {
                        showingResetConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Reset All Statistics")
                        }
                    }
                } header: {
                    Text("Data")
                } footer: {
                    Text("This will permanently delete all your water tracking history and reset your streak")
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Link(destination: URL(string: "https://kellyclaudeai.com/hydrotrack/privacy")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://kellyclaudeai.com/hydrotrack/support")!) {
                        HStack {
                            Text("Contact Support")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    
                    Button {
                        if let url = URL(string: "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        HStack {
                            Text("Rate HydroTrack")
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Reset All Data?", isPresented: $showingResetConfirmation, titleVisibility: .visible) {
                Button("Reset Everything", role: .destructive) {
                    settingsViewModel.resetStatistics()
                    waterViewModel.entries.removeAll()
                    HapticManager.success()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently delete all your water tracking history, achievements, and reset your streak. This cannot be undone.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsViewModel())
        .environmentObject(HealthKitManager())
        .environmentObject(WaterViewModel())
}
