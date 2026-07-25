//
//  ContentView.swift
//  WaterIntakeTracker Watch App
//
//  Created by Deepa Kale on 7/24/26.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: WaterDataStore

    // Quick-log buttons.  
    let quickAmounts = [8, 12, 16]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {

                    // Progress ring showing today's total vs. goal
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 8)
                            .opacity(0.2)
                            .foregroundColor(.blue)

                        Circle()
                            .trim(from: 0, to: store.progress)
                            .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut, value: store.progress)

                        VStack {
                            Text("\(store.todayTotal)")
                                .font(.title2)
                                .bold()
                            Text("of \(store.dailyGoal) oz")
                                .font(.caption2)
                        }
                    }
                    .frame(width: 80, height: 80)
                    .padding(.top, 4)

                    // Quick-log buttons
                    HStack(spacing: 6) {
                        ForEach(quickAmounts, id: \.self) { amount in
                            Button {
                                store.logWater(amount: amount)
                            } label: {
                                Text("+\(amount)")
                                    .font(.footnote)
                            }
                            .buttonStyle(.bordered)
                        }
                    }

                    // Undo button, only shows if there's something to undo today
                    if !store.todayEntries.isEmpty {
                        Button(role: .destructive) {
                            store.removeLastEntry()
                        } label: {
                            Text("Undo Last")
                                .font(.caption2)
                        }
                    }

                    NavigationLink("History") {
                        HistoryView()
                    }
                    .font(.caption)

                    NavigationLink("Edit Goal") {
                        EditGoalView()
                    }
                    .font(.caption)
                }
                .padding()
            }
            .navigationTitle("Water")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WaterDataStore())
}
