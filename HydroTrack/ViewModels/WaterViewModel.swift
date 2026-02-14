import Foundation
import SwiftUI

class WaterViewModel: ObservableObject {
    @Published var entries: [WaterEntry] = []
    @Published var showingCustomAmount = false
    @Published var showingCelebration = false
    @Published var showingStreak = false
    @Published var currentStreak = 0
    
    private let entriesKey = "waterEntries"
    private let streakKey = "waterStreak"
    private let lastLogDateKey = "lastLogDate"
    
    init() {
        loadEntries()
        updateStreak()
    }
    
    var todayEntries: [WaterEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return entries.filter { calendar.isDate($0.timestamp, inSameDayAs: today) }
    }
    
    var totalToday: Double {
        todayEntries.reduce(0) { $0 + $1.amount }
    }
    
    func progressPercentage(goal: Double) -> Double {
        min(totalToday / goal, 1.5) // Allow showing over 100%
    }
    
    func remainingAmount(goal: Double) -> Double {
        max(0, goal - totalToday)
    }
    
    func addEntry(amount: Double) {
        let entry = WaterEntry(amount: amount)
        entries.insert(entry, at: 0)
        saveEntries()
        updateStreak()
        
        // Show celebration if goal reached
        if totalToday >= 64 && !showingCelebration {
            showingCelebration = true
            HapticManager.success()
        } else {
            HapticManager.impact(.medium)
        }
    }
    
    func deleteEntry(_ entry: WaterEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
        HapticManager.impact(.medium)
    }
    
    func updateEntry(_ entry: WaterEntry, newAmount: Double) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index].amount = newAmount
            saveEntries()
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([WaterEntry].self, from: data) {
            entries = decoded
        }
    }
    
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Check if logged today
        let loggedToday = entries.contains { calendar.isDate($0.timestamp, inSameDayAs: today) }
        
        if loggedToday {
            if let lastDate = UserDefaults.standard.object(forKey: lastLogDateKey) as? Date {
                let daysBetween = calendar.dateComponents([.day], from: lastDate, to: today).day ?? 0
                
                if daysBetween == 0 {
                    // Same day, maintain streak
                    currentStreak = UserDefaults.standard.integer(forKey: streakKey)
                } else if daysBetween == 1 {
                    // Consecutive day, increment streak
                    currentStreak = UserDefaults.standard.integer(forKey: streakKey) + 1
                    UserDefaults.standard.set(currentStreak, forKey: streakKey)
                    
                    if currentStreak == 7 || currentStreak == 14 || currentStreak == 30 {
                        showingStreak = true
                    }
                } else {
                    // Streak broken, reset to 1
                    currentStreak = 1
                    UserDefaults.standard.set(1, forKey: streakKey)
                }
            } else {
                // First time logging
                currentStreak = 1
                UserDefaults.standard.set(1, forKey: streakKey)
            }
            
            UserDefaults.standard.set(today, forKey: lastLogDateKey)
        } else {
            currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        }
    }
    
    // Statistics
    func weeklyData() -> [Double] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return (0..<7).map { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { return 0 }
            return entries
                .filter { calendar.isDate($0.timestamp, inSameDayAs: date) }
                .reduce(0) { $0 + $1.amount }
        }.reversed()
    }
    
    func averagePerDay(days: Int = 7) -> Double {
        let data = weeklyData()
        let sum = data.reduce(0, +)
        return data.isEmpty ? 0 : sum / Double(data.count)
    }
}
