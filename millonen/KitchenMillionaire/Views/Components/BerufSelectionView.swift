//
//  BerufSelectionView.swift
//  millonen
//
//  Created by Andreas Pelczer on 28.12.25.
//

import Foundation
import SwiftUI

struct BerufSelectionView: View {
    // Liste der verfügbaren Berufe
    let berufe = [
        Beruf(name: "Schlosser", imageName: "hammer.fill", fileName: "Schlosser"),
        Beruf(name: "Koch", imageName: "stove.fill", fileName: "Koch"),
        Beruf(name: "Lagerist", imageName: "cloud.sun.fill", fileName: "Metzger"),
        Beruf(name: "Schweißer", imageName: "fuelpump.fill", fileName: "Schweisser")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrund (passend zum Quiz-Design)
                Color.black.ignoresSafeArea()
                LinearGradient(colors: [Color.blue.opacity(0.4), Color.black], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Wähle deinen Beruf")
                            .font(.system(size: 28, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        // Erstellt für jeden Beruf eine Auswahlkarte
                        ForEach(berufe) { beruf in
                            NavigationLink(destination: QuizView(gewaehlterBeruf: beruf.fileName)) {
                                BerufCard(beruf: beruf)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Subview für die Berufskarte
struct BerufCard: View {
    let beruf: Beruf
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: beruf.imageName)
                .font(.system(size: 30))
                .foregroundColor(.yellow)
                .frame(width: 60)
            
            Text(beruf.name)
                .font(.title2.bold())
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}
