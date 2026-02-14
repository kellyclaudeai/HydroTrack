import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var userProfile: UserProfile {
        didSet {
            saveProfile()
        }
    }
    
    @Published var colorScheme: ColorScheme?
    
    private let profileKey = "userProfile"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decoded
        } else {
            userProfile = UserProfile()
        }
    }
    
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    func completeOnboarding() {
        userProfile.hasCompletedOnboarding = true
        saveProfile()
    }
    
    func resetStatistics() {
        UserDefaults.standard.removeObject(forKey: "waterEntries")
        UserDefaults.standard.removeObject(forKey: "waterStreak")
        UserDefaults.standard.removeObject(forKey: "lastLogDate")
    }
    
    func exportData() -> String {
        // Generate CSV of water entries
        return "Date,Time,Amount (oz)\n" // Placeholder for actual export
    }
}
