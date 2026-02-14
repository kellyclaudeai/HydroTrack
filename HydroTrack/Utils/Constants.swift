import Foundation

struct Constants {
    // Quick log amounts (oz)
    static let quickLogAmounts: [Double] = [8, 16, 24]
    
    // Common container presets (oz)
    static let commonContainers = [
        ("Coffee Cup", 12.0),
        ("Water Bottle", 16.9),
        ("Large Glass", 20.0),
        ("Sports Bottle", 32.0)
    ]
    
    // Hydration fun facts
    static let hydrationFacts = [
        "Your brain is 73% water! 🧠",
        "Water helps regulate body temperature 🌡️",
        "Staying hydrated improves focus and mood 😊",
        "Your muscles are 79% water 💪",
        "Proper hydration aids digestion 🥗",
        "Water helps transport nutrients throughout your body 🩸",
        "Drinking water can boost your metabolism ⚡",
        "Your heart is 73% water ❤️",
        "Water helps cushion your joints 🦴",
        "Staying hydrated improves skin health ✨"
    ]
    
    // Goal ranges
    static let minGoal: Double = 32
    static let maxGoal: Double = 256
    static let defaultGoal: Double = 64
    
    // Reminder ranges
    static let minReminderInterval = 1
    static let maxReminderInterval = 4
}
