//
//  WaterDataStore.swift
//  WaterIntakeTracker
//
//  Created by Deepa Kale on 7/24/26.
//
import Foundation
import Combine

// "brain" of the app. It holds all water entries,
// calculates today's total, tracks the user's daily goal, and
// saves/loads everything from UserDefaults so data survives restarts.
class WaterDataStore: ObservableObject {

    @Published var entries: [WaterEntry] = []
    @Published var dailyGoal: Int = 64          // ounces, fallback default before onboarding
    @Published var hasCompletedOnboarding: Bool = false

    private let entriesKey = "waterEntries"
    private let goalKey = "dailyGoal"
    private let onboardingKey = "hasCompletedOnboarding"

    init() {
        // Load onboarding status first
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)

        // Load saved goal if one exists; otherwise dailyGoal stays at the default above
        if UserDefaults.standard.object(forKey: goalKey) != nil {
            dailyGoal = UserDefaults.standard.integer(forKey: goalKey)
        }

        loadEntries()
    }

    // MARK: - Computed values

    var todayEntries: [WaterEntry] {
        entries.filter { Calendar.current.isDateInToday($0.timestamp) }
    }

    var todayTotal: Int {
        todayEntries.reduce(0) { $0 + $1.amount }
    }

    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(todayTotal) / Double(dailyGoal), 1.0)
    }

    // MARK: - Goal & onboarding actions

    // Call this any time the user changes their goal, including during onboarding.
    func setDailyGoal(_ goal: Int) {
        dailyGoal = goal
        UserDefaults.standard.set(goal, forKey: goalKey)
    }

    // Call this once, when the user finishes the first-launch goal setup screen.
    func completeOnboarding(withGoal goal: Int) {
        setDailyGoal(goal)
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    // MARK: - Water logging actions

    func logWater(amount: Int) {
        let entry = WaterEntry(amount: amount, timestamp: Date())
        entries.append(entry)
        saveEntries()
    }

    // Removes the most recent entry logged TODAY (undo button).
    func removeLastEntry() {
        let sortedToday = todayEntries.sorted { $0.timestamp > $1.timestamp }
        guard let lastEntry = sortedToday.first,
              let index = entries.firstIndex(where: { $0.id == lastEntry.id }) else {
            return
        }
        entries.remove(at: index)
        saveEntries()
    }

    // Returns totals for the last `days` days, most recent first.
    func entriesGrouped(byDay days: Int) -> [(date: Date, total: Int)] {
        let calendar = Calendar.current
        var result: [(Date, Int)] = []
        for offset in 0..<days {
            guard let day = calendar.date(byAdding: .day, value: -offset, to: Date()) else { continue }
            let total = entries
                .filter { calendar.isDate($0.timestamp, inSameDayAs: day) }
                .reduce(0) { $0 + $1.amount }
            result.append((day, total))
        }
        return result
    }

    // MARK: - Saving

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: entriesKey)
        }
    }

    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([WaterEntry].self, from: data) {
            entries = decoded
        }
    }
}
