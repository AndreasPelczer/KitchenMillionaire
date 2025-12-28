//
//  PrizeTier.swift
//  millonen
//
//  Created by Andreas Pelczer on 27.12.25.
//

import Foundation

/// Repräsentiert eine Stufe auf der Geldleiter.
struct PrizeTier: Identifiable {
    let id = UUID()
    let level: Int        // Stufe 1 bis 15
    let amount: String    // z.B. "500 €"
    let isSafeZone: Bool  // Ist das eine Gewinn-Sicherung (z.B. 500€ und 16.000€)?
}
