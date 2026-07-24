//
//  WaterIntakeTrackerApp.swift
//  WaterIntakeTracker Watch App
//
//  Created by Deepa Kale on 7/24/26.
//

import SwiftUI

@main
struct WaterIntakeTrackerApp: App {
    @StateObject private var store = WaterDataStore()

    var body: some Scene {
        WindowGroup {
            Group {
                if store.hasCompletedOnboarding {
                    ContentView()
                } else {
                    GoalSetupView()
                }
            }
            .environmentObject(store)
            .onAppear {
                NotificationManager.shared.requestAuthorization()
                NotificationManager.shared.scheduleDailyReminder()
            }
        }
    }
}
