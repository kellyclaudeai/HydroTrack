import SwiftUI

struct RemindersView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable Reminders", isOn: $notificationManager.remindersEnabled)
                        .onChange(of: notificationManager.remindersEnabled) { _, newValue in
                            if newValue {
                                notificationManager.scheduleReminders()
                            } else {
                                notificationManager.cancelReminders()
                            }
                            HapticManager.selection()
                        }
                    
                    if !notificationManager.isAuthorized && notificationManager.remindersEnabled {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Theme.warningOrange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Notifications Disabled")
                                    .font(.subheadline.bold())
                                
                                Text("Please enable notifications in Settings")
                                    .font(.caption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                            
                            Spacer()
                            
                            Button("Open Settings") {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .font(.caption)
                        }
                        .padding(.vertical, Theme.spacingS)
                    }
                } header: {
                    Text("Smart Reminders")
                } footer: {
                    Text("We'll remind you during your active hours to stay hydrated")
                }
                
                if notificationManager.remindersEnabled {
                    Section {
                        VStack(alignment: .leading, spacing: Theme.spacingM) {
                            Text("Reminder Frequency")
                                .font(.subheadline)
                            
                            HStack {
                                Text("Every \(notificationManager.reminderInterval) hours")
                                    .font(.body)
                                    .foregroundColor(Theme.textSecondary)
                                
                                Spacer()
                            }
                            
                            Slider(
                                value: Binding(
                                    get: { Double(notificationManager.reminderInterval) },
                                    set: { notificationManager.reminderInterval = Int($0) }
                                ),
                                in: Double(Constants.minReminderInterval)...Double(Constants.maxReminderInterval),
                                step: 1
                            )
                            .tint(Theme.primaryBlue)
                            .onChange(of: notificationManager.reminderInterval) { _, _ in
                                HapticManager.selection()
                                notificationManager.scheduleReminders()
                            }
                        }
                        .padding(.vertical, Theme.spacingS)
                    } header: {
                        Text("Frequency")
                    }
                    
                    Section {
                        HStack {
                            Text("Start Time")
                            Spacer()
                            Text(formatHour(notificationManager.quietHoursEnd))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Picker("Start Time", selection: $notificationManager.quietHoursEnd) {
                            ForEach(5...12, id: \.self) { hour in
                                Text(formatHour(hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: notificationManager.quietHoursEnd) { _, _ in
                            notificationManager.scheduleReminders()
                        }
                        
                        HStack {
                            Text("End Time")
                            Spacer()
                            Text(formatHour(notificationManager.quietHoursStart))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        Picker("End Time", selection: $notificationManager.quietHoursStart) {
                            ForEach(18...23, id: \.self) { hour in
                                Text(formatHour(hour)).tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .onChange(of: notificationManager.quietHoursStart) { _, _ in
                            notificationManager.scheduleReminders()
                        }
                    } header: {
                        Text("Active Hours")
                    } footer: {
                        Text("You'll only receive reminders between these times")
                    }
                    
                    Section {
                        Button {
                            notificationManager.testReminder()
                            HapticManager.success()
                        } label: {
                            HStack {
                                Image(systemName: "bell.badge.fill")
                                Text("Send Test Reminder")
                            }
                        }
                    } footer: {
                        Text("Test reminder will appear in 2 seconds")
                    }
                }
            }
            .navigationTitle("Reminders")
        }
    }
    
    private func formatHour(_ hour: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        var components = DateComponents()
        components.hour = hour
        components.minute = 0
        
        if let date = Calendar.current.date(from: components) {
            return formatter.string(from: date)
        }
        return "\(hour):00"
    }
}

#Preview {
    RemindersView()
        .environmentObject(NotificationManager())
}
