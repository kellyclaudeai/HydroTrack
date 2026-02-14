import SwiftUI

@main
struct HydroTrackApp: App {
    @StateObject private var waterViewModel = WaterViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var notificationManager = NotificationManager()
    
    init() {
        // Apply theme on launch
        Theme.apply()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(waterViewModel)
                .environmentObject(settingsViewModel)
                .environmentObject(healthKitManager)
                .environmentObject(notificationManager)
                .preferredColorScheme(settingsViewModel.colorScheme)
                .onAppear {
                    healthKitManager.requestAuthorization()
                    notificationManager.requestAuthorization()
                }
        }
    }
}
