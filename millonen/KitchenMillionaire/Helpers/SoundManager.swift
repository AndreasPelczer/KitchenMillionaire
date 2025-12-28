//
//  SoundManager.swift
//  millonen
//
//  Created by Andreas Pelczer on 27.12.25.
//
import AVFoundation
import UIKit

class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?

    enum SoundOption: String {
        case correct   // Dateiname: correct.mp3
        case wrong     // Dateiname: wrong.mp3
        case applause  // Dateiname: applause.mp3 (für Sieg)
        case click     // Dateiname: click.mp3
    }

    // Spielt einen Sound ab
    func playSound(sound: SoundOption) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Fehler beim Abspielen des Sounds: \(error.localizedDescription)")
        }
    }

    // Erzeugt Vibrationen (Haptics)
    func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    // Speziell für Erfolg (Vibriert zweimal kurz)
    func triggerNotificationHaptic(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
