# Lyrics + Quiz & Matching Demo App
*A Flutter + Riverpod technical assessment project*

This repository contains a Flutter application demonstrating two independent features:

1. A **lyrics-synchronized video player** with word-level highlighting and a comprehension quiz.  
2. A **user-matching flow** with mock profiles, a modal animation, and a full profile screen.

It is structured using a modular architecture, Riverpod state management, and `go_router` for navigation.

---

## ✨ Features

### 🎵 Test #1 — Lyrics + Quiz
- Vertical video playback (`assets/videos/louane.mp4`).
- Parses an `.srt` subtitle file into:
  - Word-level timestamps  
  - Auto-grouped phrases based on punctuation and timing
- Karaoke-style highlighting:
  - Past word → dimmed  
  - Current word → highlighted  
  - Future words → neutral
- A 3-question quiz with:
  - Answer selection
  - Answer validation on submission
  - Visual feedback (correct / selected / incorrect)
  - Score summary and retake button

### 🤝 Test #2 — Matching + Profiles
- Scrollable list of mock “language partner” users.
- Bottom-sheet matching workflow:
  - Loading state
  - Success animation
  - “View Profile” button
- Full profile screen including:
  - Image banner  
  - Name, age, country and language  
  - Bio and interests  
  - Mock interaction buttons (Message / Video Call)

---

## 🧱 Tech Stack

- **Flutter 3+**
- **Riverpod** (StateNotifier + providers)
- **go_router** (typed declarative navigation)
- **video_player** (asset-based video playback)
- **Material 3** theme with a custom color scheme

---

## 📁 Project Structure

lib/
├── core/
│ ├── constants/ # Spacing, radii, durations, aspect ratios
│ ├── theme/ # Material 3 theme setup
│ └── utils/
│ └── srt_parser.dart # SRT file → words → phrases
│
├── features/
│ ├── lyrics_quiz/
│ │ ├── models/ # Word, LyricPhrase, Question
│ │ ├── providers/ # Lyrics and quiz state, video controller
│ │ ├── screens/ # LyricsScreen, QuizScreen
│ │ └── widgets/ # VideoPlayerWidget, LyricsDisplay, QuizQuestionCard
│ │
│ └── matching/
│ ├── models/ # User model + sample users
│ ├── providers/ # Matching state machine
│ ├── screens/ # UserListScreen, ProfileScreen
│ └── widgets/ # User cards, matching modal
│
├── home/
│ └── home_screen.dart
│
├── router/
│ └── app_router.dart
│
└── main.dart
