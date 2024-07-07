//
//  TranscriptionModel.swift
//  JestVids
//
//  Created by Vardhan Chopada on 7/7/24.
//

import Foundation

struct TranscriptionItem: Codable {
    let startTime: Double
    let endTime: Double
    let text: String
}
