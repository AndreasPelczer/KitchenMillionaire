//
//  PrizeManager.swift
//  millonen
//
//  Created by Andreas Pelczer on 27.12.25.
//

import Foundation

/// Dieser Manager verwaltet die Gewinnstufen der Gastro-Show.
class PrizeManager {
    
    /// Erstellt die klassische Gewinnleiter.
    static func getPrizeLeiter() -> [PrizeTier] {
        return [
            PrizeTier(level: 15, amount: "1.000.000 €", isSafeZone: true),
            PrizeTier(level: 14, amount: "500.000 €", isSafeZone: false),
            PrizeTier(level: 13, amount: "125.000 €", isSafeZone: false),
            PrizeTier(level: 12, amount: "64.000 €", isSafeZone: false),
            PrizeTier(level: 11, amount: "32.000 €", isSafeZone: false),
            PrizeTier(level: 10, amount: "16.000 €", isSafeZone: true),
            PrizeTier(level: 9, amount: "8.000 €", isSafeZone: false),
            PrizeTier(level: 8, amount: "4.000 €", isSafeZone: false),
            PrizeTier(level: 7, amount: "2.000 €", isSafeZone: false),
            PrizeTier(level: 6, amount: "1.000 €", isSafeZone: false),
            PrizeTier(level: 5, amount: "500 €", isSafeZone: true),
            PrizeTier(level: 4, amount: "300 €", isSafeZone: false),
            PrizeTier(level: 3, amount: "200 €", isSafeZone: false),
            PrizeTier(level: 2, amount: "100 €", isSafeZone: false),
            PrizeTier(level: 1, amount: "50 €", isSafeZone: false)
        ]
    }
}
