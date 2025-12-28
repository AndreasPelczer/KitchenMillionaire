# KitchenMillionaire
KitchenMillionaire
# 🍳 KitchenMillionaire (Berufs-Quiz)

Ein modulares Quiz-Spiel für iOS, entwickelt mit **SwiftUI** im **MVVM-Entwurfsmuster**. Ursprünglich für das Gastgewerbe konzipiert, bietet die App nun eine Plattform für verschiedene Berufsfelder wie Metallbau, Kochkunst und Handwerk.



## 🚀 Features

- **Modulare Berufswahl:** Einfaches Hinzufügen neuer Berufe über CSV-Dateien.
- **Echter Quiz-Flair:** Gewinnleiter von 50 € bis 1.000.000 €.
- **Klassische Joker:** - **50:50:** Streicht zwei falsche Antworten.
  - **Publikum:** Visualisiertes Votum mittels Balkendiagramm.
  - **Telefon:** Experten-Tipp mit variablen Antwortsätzen.
- **Modernes UI:** Neon-Effekte, flüssige Animationen und haptisches Feedback.
- **Audio-Erlebnis:** Integrierter `SoundManager` für korrektes/falsches Feedback und Sieg-Effekte (Konfetti/Applaus).

## 🛠 Architektur & Technik

Die App folgt strikt dem **MVVM-Muster**, um Geschäftslogik und UI sauber zu trennen:

- **Model:** `Question` und `Beruf` Datenstrukturen.
- **View:** Deklarative UI-Komponenten in SwiftUI, aufgeteilt in Hauptansichten und wiederverwendbare Subviews.
- **ViewModel:** Zentrale Steuerung des Spielzustands, Joker-Logik und Daten-Parsing.
- **Resources:** Dynamisches Laden von Inhalten über semikolon-getrennte CSV-Dateien.

## 📁 Projektstruktur

```text
KitchenMillionaire/
├── Models/           # Datenstrukturen (Question, Beruf, PrizeTier)
├── ViewModels/       # Spiellogik & SoundManagement
├── Views/
│   ├── Main/         # Berufsauswahl, Haupt-Quizview
│   └── Components/   # Neon-Buttons, Joker-Overlays, Konfetti
├── Resources/        # CSV-Dateien (Koch.csv, Schlosser.csv, etc.)
└── Helpers/          # CSV-Parser & String-Erweiterungen
