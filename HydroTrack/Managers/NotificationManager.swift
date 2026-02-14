import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var isAuthorized = false
    @Published var remindersEnabled = false
    @Published var reminderInterval: Int = 2 // hours
    @Published var quietHoursStart = 22 // 10 PM
    @Published var quietHoursEnd = 8 // 8 AM
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if let error = error {
                    print("Notification authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func scheduleReminders() {
        guard isAuthorized && remindersEnabled else { return }
        
        // Cancel existing notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // Schedule reminders throughout the day
        let center = UNUserNotificationCenter.current()
        
        let messages = [
            "Time to hydrate! 💧",
            "Don't forget to drink water! 🌊",
            "Stay hydrated! 💙",
            "Water break time! 💧",
            "Your body needs water! 🥤"
        ]
        
        for hour in stride(from: quietHoursEnd, to: quietHoursStart, by: reminderInterval) {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0
            
            let content = UNMutableNotificationContent()
            content.title = "HydroTrack"
            content.body = messages.randomElement() ?? "Time to drink water!"
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "water-reminder-\(hour)", content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func cancelReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func testReminder() {
        let content = UNMutableNotificationContent()
        content.title = "HydroTrack"
        content.body = "This is a test reminder! 💧"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "test-reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send test notification: \(error.localizedDescription)")
            }
        }
    }
}
