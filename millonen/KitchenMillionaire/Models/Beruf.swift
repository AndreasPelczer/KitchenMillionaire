//
//  Beruf.swift
//  millonen
//
//  Created by Andreas Pelczer on 28.12.25.
//

import Foundation

struct Beruf: Identifiable {
    let id = UUID()
    let name: String      // Anzeigename (z.B. "Industriemeister Metall")
    let imageName: String // Icon Name (SF Symbols)
    let fileName: String  // Der exakte Name deiner CSV (z.B. "Schlosser")
}

