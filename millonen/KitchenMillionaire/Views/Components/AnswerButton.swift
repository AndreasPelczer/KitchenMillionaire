//
//  AnswerButton.swift
//  millonen
//
//  Created by Andreas Pelczer on 27.12.25.
//

import Foundation
import SwiftUI

/// Ein einzelner Button für eine Antwort.
/// Ausgelagert, um die Hauptview nicht mit Styling-Code zu "verpesten".
struct AnswerButton: View {
    let text: String
    let isSelected: Bool
    // Neues Feld, um die richtige Farbe nach dem Einloggen zu zeigen
    var checkState: AnswerCheckState = .none
    let action: () -> Void
    
    enum AnswerCheckState {
        case none, checking, correct, wrong
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .frame(height: 60)
            .background(backgroundColor) // Wir nutzen eine berechnete Farbe
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.white : Color.white.opacity(0.3), lineWidth: 2)
            )
        }
        .padding(.horizontal)
    }
    
    // Die Logik für die Küchen-Farben
    var backgroundColor: Color {
        if isSelected {
            return Color.orange // "Eingeloggt"
        }
        return Color.blue.opacity(0.4) // Standard
    }
}
