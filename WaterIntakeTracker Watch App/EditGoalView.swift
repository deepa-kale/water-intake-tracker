//
//  Untitled.swift
//  WaterIntakeTracker
//
//  Created by Deepa Kale on 7/24/26.
//

import SwiftUI

// Reachable any time from the main screen so the user can
// change their daily goal after onboarding is done.
struct EditGoalView: View {
    @EnvironmentObject var store: WaterDataStore
    @Environment(\.dismiss) var dismiss

    @State private var selectedGoal: Int = 64

    let goalOptions = Array(stride(from: 16, through: 200, by: 8))

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Edit Daily Goal")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Picker("Goal", selection: $selectedGoal) {
                    ForEach(goalOptions, id: \.self) { value in
                        Text("\(value) oz").tag(value)
                    }
                }
                .labelsHidden()
                .frame(height: 60)

                Button {
                    store.setDailyGoal(selectedGoal)
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.footnote)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding()
        }
        // Pre-fill the picker with the user's current goal when this screen opens
        .onAppear {
            selectedGoal = store.dailyGoal
        }
    }
}

#Preview {
    EditGoalView()
        .environmentObject(WaterDataStore())
}
