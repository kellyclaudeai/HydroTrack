import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        if !settingsViewModel.userProfile.hasCompletedOnboarding {
            OnboardingView()
        } else {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "drop.fill")
                }
                .tag(0)
            
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            RemindersView()
                .tabItem {
                    Label("Reminders", systemImage: "bell.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(Theme.primaryBlue)
    }
}

#Preview {
    ContentView()
        .environmentObject(WaterViewModel())
        .environmentObject(SettingsViewModel())
        .environmentObject(HealthKitManager())
        .environmentObject(NotificationManager())
}
