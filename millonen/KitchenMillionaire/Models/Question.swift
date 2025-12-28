//
//  Question.swift
//  millonen
//
//  Created by Andreas Pelczer on 27.12.25.
//

import Foundation

struct Question: Identifiable {
    let id = UUID()
    let text: String
    let options: [String]
    let correctAnswerIndex: Int
    let level: Int
    let explanation: String
    var hiddenIndices: [Int] = []
}
