//
//  GoalSetupView.swift
//  WaterIntakeTracker
//
//  Created by Deepa Kale on 7/24/26.
//
import SwiftUI

// Shown only once, the very first time the app is launched.
// Asks the user to set their target daily water intake before
// they can use the rest of the app.
struct GoalSetupView: View {
    @EnvironmentObject var store: WaterDataStore

    // Start the picker at a reasonable default (64 oz)
    @State private var selectedGoal: Int = 64

    let goalOptions = Array(stride(from: 16, through: 200, by: 8)) // 16...200 oz in steps of 8

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("💧")
                    .font(.system(size: 40))

                Text("Set Daily Goal")
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("How many ounces of water do you want to drink each day?")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                Picker("Goal", selection: $selectedGoal) {
                    ForEach(goalOptions, id: \.self) { value in
                        Text("\(value) oz").tag(value)
                    }
                }
                .labelsHidden()
                .frame(height: 60)

                Button {
                    store.completeOnboarding(withGoal: selectedGoal)
                } label: {
                    Text("Get Started")
                        .font(.footnote)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .padding()
        }
    }
}

#Preview {
    GoalSetupView()
        .environmentObject(WaterDataStore())
}
