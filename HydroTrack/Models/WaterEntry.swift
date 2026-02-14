import Foundation

struct WaterEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var amount: Double // in ounces
    var timestamp: Date
    var note: String?
    
    init(id: UUID = UUID(), amount: Double, timestamp: Date = Date(), note: String? = nil) {
        self.id = id
        self.amount = amount
        self.timestamp = timestamp
        self.note = note
    }
    
    var amountInML: Double {
        amount * 29.5735 // 1 oz = 29.5735 ml
    }
    
    func formattedAmount(useMetric: Bool) -> String {
        if useMetric {
            return String(format: "%.0f ml", amountInML)
        } else {
            return String(format: "%.0f oz", amount)
        }
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}
