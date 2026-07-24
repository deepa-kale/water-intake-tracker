//
//  HistoryView.swift
//  WaterIntakeTracker
//
//  Created by Deepa Kale on 7/24/26.
//
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: WaterDataStore

    var body: some View {
        List(store.entriesGrouped(byDay: 7), id: \.date) { item in
            HStack {
                Text(item.date, style: .date)
                    .font(.caption2)
                Spacer()
                Text("\(item.total) oz")
                    .font(.caption2)
                    .foregroundColor(item.total >= store.dailyGoal ? .green : .primary)
            }
        }
        .navigationTitle("History")
    }
}

#Preview {
    HistoryView()
        .environmentObject(WaterDataStore())
}
