import SwiftUI

struct QuizView: View {
    // Verknüpfung zum ViewModel (Steuerzentrale für Logik)
    @StateObject private var viewModel = QuizViewModel()
    
    // Lokale Zustände für die Anzeige der Joker-Fenster
    @State private var showPublikumChart = false
    @State private var showTelefonAnruf = false
    @State private var publikumsDaten: [Double] = [0, 0, 0, 0]
    @State private var telefonTipp: String = ""
    
    let gewaehlterBeruf: String
    
    var body: some View {
        ZStack {
            // --- 1. HINTERGRUND ---
            Color.black.ignoresSafeArea()
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.black]),
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            // --- 2. DAS FEUERWERK ---
            if viewModel.showConfetti {
                GeometryReader { geo in
                    ForEach(0..<50, id: \.self) { i in
                        ConfettiPiece(index: i, size: geo.size)
                    }
                }
                .ignoresSafeArea()
                .zIndex(10)
            }
            
            // --- 3. HAUPT-UI ---
            VStack(spacing: 0) {
                // ZONE 1: KOPFZEILE (Stand & Reset)
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("STAND").font(.caption.bold()).foregroundColor(.gray)
                        Text(viewModel.currentPrize).font(.title).bold().foregroundColor(.yellow)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // NEON RESET BUTTON
                    Button(action: {
                        SoundManager.instance.triggerHaptic(style: .medium) // Spürbarer Klick
                        SoundManager.instance.playSound(sound: .click)      // Klick-Sound
                        viewModel.setupGame()
                    }) {
                        Text("nochmal")
                            .font(.caption.bold())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .foregroundColor(.red)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 2)
                                    .shadow(color: .red, radius: 2)
                                    .shadow(color: .red, radius: 7)
                            )
                            .shadow(color: .red.opacity(0.5), radius: 2)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Color.clear.frame(maxWidth: .infinity)
                }
                .padding(.horizontal).padding(.top, 15).frame(height: 70)

                // ZONE 2: JOKER-LEISTE
                HStack(spacing: 12) {
                    JokerButton(icon: "bolt.shield.fill", label: "50:50", isUsed: viewModel.isFiftyFiftyUsed) {
                        viewModel.useFiftyFifty()
                    }
                    
                    JokerButton(icon: "chart.bar.fill", label: "Publikum", isUsed: viewModel.isPublikumUsed) {
                        viewModel.isPublikumUsed = true
                        berechnePublikum()
                        showPublikumChart = true
                    }
                    
                    JokerButton(icon: "phone.fill", label: "Telefon", isUsed: viewModel.isTelefonUsed) {
                        viewModel.isTelefonUsed = true
                        berechneTelefon()
                        showTelefonAnruf = true
                    }
                    
                    Spacer()
                    
                    PrizeListView(tiers: viewModel.prizeLeiter, currentLevel: viewModel.currentQuestionIndex)
                        .scaleEffect(0.7)
                        .frame(width: 120, height: 150)
                }
                .padding(.horizontal)

                Divider().background(Color.gray.opacity(0.3)).padding(.vertical, 10)

                // ZONE 3: SPIELBEREICH
                ScrollView {
                    VStack(spacing: 25) {
                        if viewModel.isGameOver {
                            // SIEGER-BILDSCHIRM
                            VStack(spacing: 25) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 80))
                                    .foregroundColor(.yellow)
                                    .shadow(color: .orange, radius: 10)
                                Text("MILLIONÄR!")
                                    .font(.system(size: 40, weight: .black))
                                    .foregroundColor(.yellow)
                                Text(viewModel.currentPrize)
                                    .font(.title).bold()
                                    .foregroundColor(.white)
                                Button("NEUE RUNDE") {
                                    viewModel.setupGame()
                                }.buttonStyle(.borderedProminent).tint(.orange)
                            }
                            .padding(.top, 40)
                            .transition(.scale)
                            
                        } else if let question = viewModel.currentQuestion {
                            // FRAGEN-ANZEIGE
                            Text(question.text)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 15).fill(Color.blue.opacity(0.3)))
                                .padding(.top, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(0..<question.options.count, id: \.self) { index in
                                    if !question.hiddenIndices.contains(index) {
                                        AnswerButton(text: question.options[index], isSelected: viewModel.selectedAnswerIndex == index) {
                                            viewModel.submitAnswer(at: index)
                                        }
                                    } else {
                                        Color.clear.frame(height: 55)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // --- EBENE 4: JOKER OVERLAYS ---
            if showPublikumChart {
                Color.black.opacity(0.4).ignoresSafeArea().onTapGesture { showPublikumChart = false }
                PublikumOverlay(daten: publikumsDaten) { showPublikumChart = false }
                    .zIndex(20)
            }
            
            if showTelefonAnruf {
                Color.black.opacity(0.4).ignoresSafeArea().onTapGesture { showTelefonAnruf = false }
                TelefonOverlay(tipp: telefonTipp) { showTelefonAnruf = false }
                    .zIndex(20)
            }
        }
        // FEHLER-SHEET
        .sheet(isPresented: $viewModel.showInfoSheet) {
            VStack(spacing: 20) {
                Text("LEIDER FALSCH").font(.title2).bold().foregroundColor(.red).padding(.top)
                Text(viewModel.currentQuestion?.explanation ?? "").padding().multilineTextAlignment(.center)
                Button("NEUSTART") { viewModel.setupGame() }.buttonStyle(.borderedProminent)
            }
            .presentationDetents([.medium])
        }
    }
    
    // --- LOGIK-FUNKTIONEN ---
    func berechnePublikum() {
        guard let question = viewModel.currentQuestion else { return }
        let correctIndex = question.correctAnswerIndex
        let chance = Int.random(in: 1...100)
        var neueDaten = [Double](repeating: 0, count: 4)
        if chance <= 70 { neueDaten[correctIndex] = Double.random(in: 45...75) }
        else { neueDaten[(correctIndex + 1) % 4] = Double.random(in: 40...60) }
        var rest = 100.0 - neueDaten.reduce(0, +)
        for i in 0..<4 { if neueDaten[i] == 0 { neueDaten[i] = rest / 3 } }
        publikumsDaten = neueDaten
    }

    func berechneTelefon() {
        guard let question = viewModel.currentQuestion else { return }
        let chance = Int.random(in: 1...100)
        let tippIndex = (chance <= 90) ? question.correctAnswerIndex : Int.random(in: 0...3)
        telefonTipp = "Ich glaube, es ist Antwort \(["A", "B", "C", "D"][tippIndex]): \(question.options[tippIndex])."
    }
}

// ==========================================================
// HIER SIND DIE BAUSTEINE (Subviews)
// ==========================================================

struct JokerButton: View {
    let icon: String
    let label: String
    let isUsed: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.title2)
                Text(label).font(.system(size: 9, weight: .bold))
            }
            .frame(width: 55, height: 55)
            .background(isUsed ? Color.gray.opacity(0.5) : Color.orange)
            .clipShape(Circle())
            .foregroundColor(.white)
        }
        .disabled(isUsed)
    }
}

struct PublikumOverlay: View {
    let daten: [Double]
    let close: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("Publikumsvotum").font(.headline).foregroundColor(.white)
            HStack(alignment: .bottom, spacing: 15) {
                ForEach(0..<4) { i in
                    VStack {
                        Text("\(Int(daten[i]))%").font(.caption2).foregroundColor(.white)
                        Rectangle().fill(Color.yellow).frame(width: 35, height: CGFloat(daten[i] * 2.0)).cornerRadius(4)
                        Text(["A", "B", "C", "D"][i]).foregroundColor(.white).bold()
                    }
                }
            }
            Button("OK", action: close).buttonStyle(.borderedProminent)
        }
        .padding(30).background(Color.blue.opacity(0.9)).cornerRadius(20).padding(30)
    }
}

struct TelefonOverlay: View {
    let tipp: String
    let close: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "phone.circle.fill").font(.system(size: 50)).foregroundColor(.white)
            Text("Telefonjoker sagt:").font(.headline).foregroundColor(.white)
            Text("\"\(tipp)\"").italic().multilineTextAlignment(.center).foregroundColor(.white).padding()
            Button("Danke!", action: close).buttonStyle(.borderedProminent).tint(.green)
        }
        .padding(25).background(Color.black.opacity(0.85)).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.green, lineWidth: 2)).padding(30)
    }
    
}
    struct ConfettiPiece: View {
        let index: Int
        let size: CGSize
        @State private var yPos: CGFloat = -100
        @State private var xPos: CGFloat = CGFloat.random(in: 0...400)
        @State private var rotation: Double = 0
        
        var body: some View {
            Text(["🎉", "🎊", "🎆", "✨", "💰"].randomElement()!)
                .font(.system(size: CGFloat.random(in: 20...40)))
                .position(x: xPos, y: yPos)
                .rotationEffect(.degrees(rotation))
                .onAppear {
                    xPos = CGFloat.random(in: 0...size.width)
                    withAnimation(Animation.linear(duration: Double.random(in: 2...4)).repeatForever(autoreverses: false)) {
                        yPos = size.height + 100
                        rotation = 360
                    }
                }
        }
    }

