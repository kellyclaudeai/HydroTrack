import SwiftUI

struct HistoryEntryRow: View {
    @EnvironmentObject var waterViewModel: WaterViewModel
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    let entry: WaterEntry
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        HStack {
            Image(systemName: "drop.fill")
                .foregroundColor(Theme.primaryBlue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(entry.amount)) oz")
                    .font(.headline)
                
                Text(entry.formattedTime)
                    .font(.caption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            Button {
                showingDeleteConfirmation = true
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(Theme.errorRed)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Theme.radiusM)
        .confirmationDialog("Delete this entry?", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private func deleteEntry() {
        healthKitManager.deleteWaterIntake(amount: entry.amount, date: entry.timestamp)
        waterViewModel.deleteEntry(entry)
    }
}

#Preview {
    HistoryEntryRow(entry: WaterEntry(amount: 16))
        .environmentObject(WaterViewModel())
        .environmentObject(HealthKitManager())
        .padding()
}
