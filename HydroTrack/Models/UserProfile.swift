import Foundation

enum ActivityLevel: String, Codable, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case active = "Active"
    case veryActive = "Very Active"
    
    var multiplier: Double {
        switch self {
        case .low: return 0.5
        case .moderate: return 0.65
        case .active: return 0.8
        case .veryActive: return 1.0
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Minimal exercise"
        case .moderate: return "Exercise 1-3 days/week"
        case .active: return "Exercise 4-5 days/week"
        case .veryActive: return "Intense daily exercise"
        }
    }
}

struct UserProfile: Codable {
    var weight: Double // in pounds
    var activityLevel: ActivityLevel
    var useMetric: Bool
    var hasCompletedOnboarding: Bool
    
    init(weight: Double = 150, activityLevel: ActivityLevel = .moderate, useMetric: Bool = false, hasCompletedOnboarding: Bool = false) {
        self.weight = weight
        self.activityLevel = activityLevel
        self.useMetric = useMetric
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
    
    var dailyGoalOz: Double {
        let baseGoal = weight * activityLevel.multiplier
        return max(64, min(baseGoal, 128)) // Clamp between 64-128 oz
    }
    
    var dailyGoalML: Double {
        dailyGoalOz * 29.5735
    }
    
    var weightInKg: Double {
        weight * 0.453592
    }
}
