//
//  PrizeListView.swift
//  millonen
//
//  Created by Andreas Pelczer on 27.12.25.
//
import Foundation
import SwiftUI
import SwiftUI

/// Die Liste der Gewinnstufen.
/// WICHTIG: Hier muss 'struct PrizeListView: View' stehen (ohne 'some')!
struct PrizeListView: View {
    let tiers: [PrizeTier]
    let currentLevel: Int
    
    var body: some View { // NUR HIER gehört das 'some' hin
        VStack(alignment: .leading, spacing: 4) {
            ForEach(tiers) { tier in
                HStack {
                    Text("\(tier.level)")
                        .font(.system(.caption, design: .monospaced))
                        .frame(width: 25)
                    
                    Text(tier.amount)
                        .fontWeight(tier.isSafeZone ? .bold : .regular)
                    
                    Spacer()
                    
                    if tier.level == currentLevel + 1 {
                        Image(systemName: "arrow.left") // Kleiner Pfeil für die aktuelle Stufe
                    }
                }
                .foregroundColor(tier.level == currentLevel + 1 ? .yellow : (tier.isSafeZone ? .white : .orange))
                .padding(.horizontal, 8)
                .background(tier.level == currentLevel + 1 ? Color.blue.opacity(0.5) : Color.clear)
            }
        }
        .frame(width: 160)
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
