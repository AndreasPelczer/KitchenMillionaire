import Foundation
import SwiftUI

class QuizViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswerIndex: Int? = nil
    @Published var isCheckingAnswer = false
    @Published var isGameOver: Bool = false
    @Published var isFiftyFiftyUsed = false
    @Published var showInfoSheet: Bool = false
    @Published var showConfetti: Bool = false
    @Published var isPublikumUsed = false
    @Published var isTelefonUsed = false
    @Published var prizeLeiter: [PrizeTier] = PrizeManager.getPrizeLeiter()

    var currentQuestion: Question? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var currentPrize: String {
        let level = currentQuestionIndex + 1
        return prizeLeiter.first(where: { $0.level == level })?.amount ?? "0 €"
    }

    init() { setupGame() }

    func setupGame() {
        isFiftyFiftyUsed = false
        isPublikumUsed = false
        isTelefonUsed = false
        showInfoSheet = false // Das sorgt dafür, dass das Fenster verschwindet
        selectedAnswerIndex = nil
            isCheckingAnswer = false
            showConfetti = false
            isGameOver = false
            currentQuestionIndex = 0
        
        let allQuestionsFromCSV = loadQuestionsFromCSV()
        if allQuestionsFromCSV.isEmpty { return }

        var selectedQuestions: [Question] = []
        
        for questionIndex in 1...15 {
            let difficultyZone: Int
            switch questionIndex {
            case 1...5:   difficultyZone = 1
            case 6...10:  difficultyZone = 2
            case 11...15: difficultyZone = 3
            default:      difficultyZone = 1
            }
            
            let possibleQs = allQuestionsFromCSV.filter { $0.level == difficultyZone }
            if let randomQ = possibleQs.randomElement() {
                selectedQuestions.append(randomQ)
            } else if let fallback = allQuestionsFromCSV.randomElement() {
                selectedQuestions.append(fallback)
            }
        }
        
        DispatchQueue.main.async {
            self.questions = selectedQuestions
            self.currentQuestionIndex = 0
            self.isGameOver = false
            self.showConfetti = false
        }
    }

    func submitAnswer(at index: Int) {
        guard !isCheckingAnswer else { return }
        selectedAnswerIndex = index
        isCheckingAnswer = true
        
        let correctIdx = currentQuestion?.correctAnswerIndex
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if index == correctIdx {
                // --- RICHTIG ---
                // Sound & Haptik
                SoundManager.instance.playSound(sound: .correct)
                SoundManager.instance.triggerNotificationHaptic(type: .success)
                
                if self.currentQuestionIndex == 14 {
                    // MILLIONÄR
                    self.showConfetti = true
                    self.isGameOver = true
                    SoundManager.instance.playSound(sound: .applause)
                } else {
                    self.goToNextQuestion()
                }
            } else {
                // --- FALSCH ---
                SoundManager.instance.playSound(sound: .wrong)
                SoundManager.instance.triggerNotificationHaptic(type: .error)
                self.showInfoSheet = true
            }
            self.isCheckingAnswer = false
        }
    }
    
    func goToNextQuestion() {
        selectedAnswerIndex = nil
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }
    }

    func useFiftyFifty() {
        guard !isFiftyFiftyUsed, let q = currentQuestion else { return }
        let correctIdx = q.correctAnswerIndex
        let wrongIndices = [0,1,2,3].filter { $0 != correctIdx }
        let toHide = Array(wrongIndices.shuffled().prefix(2))
        questions[currentQuestionIndex].hiddenIndices = toHide
        isFiftyFiftyUsed = true
    }

    private func loadQuestionsFromCSV() -> [Question] {
        var temp: [Question] = []
        guard let path = Bundle.main.path(forResource: "Question", ofType: "csv") else { return [] }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let rows = content.components(separatedBy: .newlines)
            for row in rows {
                let cleanRow = row.trimmingCharacters(in: .whitespacesAndNewlines)
                if cleanRow.isEmpty { continue }
                let cols = cleanRow.components(separatedBy: ";")
                if cols.count >= 7 {
                    let opts = [cols[1], cols[2], cols[3], cols[4]]
                    let correct = Int(cols[5].filter(\.isNumber)) ?? 0
                    let lvl = Int(cols[6].filter(\.isNumber)) ?? 1
                    temp.append(Question(text: cols[0], options: opts, correctAnswerIndex: correct, level: lvl, explanation: "Richtig ist: \(opts[correct])."))
                }
            }
        } catch { print(error) }
        return temp
    }
}
