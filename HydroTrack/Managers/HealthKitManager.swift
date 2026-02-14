import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    @Published var isAuthorized = false
    
    private let waterType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit not available")
            return
        }
        
        let typesToShare: Set<HKSampleType> = [waterType]
        let typesToRead: Set<HKObjectType> = [waterType]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                if let error = error {
                    print("HealthKit authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func saveWaterIntake(amount: Double, date: Date = Date()) {
        guard isAuthorized else { return }
        
        let quantity = HKQuantity(unit: .fluidOunceUS(), doubleValue: amount)
        let sample = HKQuantitySample(type: waterType, quantity: quantity, start: date, end: date)
        
        healthStore.save(sample) { success, error in
            if let error = error {
                print("Failed to save water intake: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteWaterIntake(amount: Double, date: Date) {
        guard isAuthorized else { return }
        
        let predicate = HKQuery.predicateForSamples(
            withStart: Calendar.current.startOfDay(for: date),
            end: Calendar.current.date(byAdding: .day, value: 1, to: date),
            options: .strictStartDate
        )
        
        healthStore.deleteObjects(of: waterType, predicate: predicate) { success, count, error in
            if let error = error {
                print("Failed to delete water intake: \(error.localizedDescription)")
            }
        }
    }
}
