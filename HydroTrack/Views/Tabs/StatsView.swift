import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var waterViewModel: WaterViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    @State private var selectedPeriod: StatsPeriod = .week
    
    enum StatsPeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingL) {
                    // Period selector
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(StatsPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Chart
                    chartView
                    
                    // Stats cards
                    VStack(spacing: Theme.spacingM) {
                        StatCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Average per Day",
                            value: "\(Int(waterViewModel.averagePerDay())) oz",
                            color: Theme.primaryBlue
                        )
                        
                        StatCard(
                            icon: "flame.fill",
                            title: "Current Streak",
                            value: "\(waterViewModel.currentStreak) days",
                            color: .orange
                        )
                        
                        StatCard(
                            icon: "drop.fill",
                            title: "Total This Week",
                            value: "\(Int(waterViewModel.weeklyData().reduce(0, +))) oz",
                            color: Theme.secondaryCyan
                        )
                        
                        StatCard(
                            icon: "target",
                            title: "Daily Goal",
                            value: "\(Int(settingsViewModel.userProfile.dailyGoalOz)) oz",
                            color: Theme.accentGreen
                        )
                    }
                    .padding(.horizontal)
                    
                    // Achievements
                    if waterViewModel.currentStreak >= 7 {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            Text("Achievements")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: Theme.spacingM) {
                                    if waterViewModel.currentStreak >= 7 {
                                        AchievementBadge(
                                            icon: "flame.fill",
                                            title: "7 Day Streak",
                                            color: .orange
                                        )
                                    }
                                    
                                    if waterViewModel.currentStreak >= 14 {
                                        AchievementBadge(
                                            icon: "flame.fill",
                                            title: "14 Day Streak",
                                            color: .red
                                        )
                                    }
                                    
                                    if waterViewModel.currentStreak >= 30 {
                                        AchievementBadge(
                                            icon: "crown.fill",
                                            title: "30 Day Streak",
                                            color: Color(hex: "FFD700")
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .background(Theme.backgroundLight)
            .navigationTitle("Statistics")
        }
    }
    
    var chartView: some View {
        VStack(alignment: .leading, spacing: Theme.spacingS) {
            Text("Daily Water Intake")
                .font(.headline)
                .padding(.horizontal)
            
            Chart {
                ForEach(Array(waterViewModel.weeklyData().enumerated()), id: \.offset) { index, amount in
                    BarMark(
                        x: .value("Day", dayLabel(for: index)),
                        y: .value("Amount", amount)
                    )
                    .foregroundStyle(Theme.primaryBlue.gradient)
                    .cornerRadius(6)
                }
                
                // Goal line
                RuleMark(y: .value("Goal", settingsViewModel.userProfile.dailyGoalOz))
                    .foregroundStyle(Theme.accentGreen)
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
            }
            .frame(height: 200)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Theme.radiusM)
        .padding(.horizontal)
    }
    
    func dayLabel(for index: Int) -> String {
        let calendar = Calendar.current
        guard let date = calendar.date(byAdding: .day, value: -(6 - index), to: Date()) else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: Theme.spacingM) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .cornerRadius(Theme.radiusS)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(Theme.textSecondary)
                
                Text(value)
                    .font(.title3.bold())
                    .foregroundColor(Theme.textPrimary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Theme.radiusM)
    }
}

struct AchievementBadge: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.spacingS) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 100)
        .padding()
        .background(Color.white)
        .cornerRadius(Theme.radiusM)
    }
}

#Preview {
    StatsView()
        .environmentObject(WaterViewModel())
        .environmentObject(SettingsViewModel())
}
