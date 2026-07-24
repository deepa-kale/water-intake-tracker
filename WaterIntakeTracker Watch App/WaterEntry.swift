//
//  WaterEntry.swift
//  WaterIntakeTracker
//
//  Created by Deepa Kale on 7/24/26.
//

import Foundation

// A single logged glass/serving of water.
struct WaterEntry: Codable, Identifiable {
    var id: UUID = UUID()
    var amount: Int      // ounces
    var timestamp: Date  // when it was logged
}
