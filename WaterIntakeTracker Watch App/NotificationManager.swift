//
//  NotificationManager.swift
//  WaterIntakeTracker
//
//  Created by Deepa Kale on 7/24/26.
//
import Foundation
import UserNotifications

// Handles requesting permission and scheduling a daily reminder
// notification to log water. Kept as a singleton for simplicity.
class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            }
        }
    }

    // Schedules a repeating daily reminder at a fixed time (3:00 PM by default).
    func scheduleDailyReminder() {
        let center = UNUserNotificationCenter.current()

        // Remove any existing reminder first so we don't stack duplicates
        center.removePendingNotificationRequests(withIdentifiers: ["dailyWaterReminder"])

        let content = UNMutableNotificationContent()
        content.title = "Stay Hydrated"
        content.body = "Don't forget to log your water intake today!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 15   // 3:00 PM - change this to whatever time you want
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyWaterReminder", content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            }
        }
    }
}
