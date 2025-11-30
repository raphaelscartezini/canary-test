# Canary Mini-App - Technical Specification

## Project Overview
Combined Flutter application implementing both Test #1 (Lyrics + Quiz) and Test #2 (Matching + Profiles) as separate features within one app.

---

## Test Requirements

### Test #1: Mini Canary Lyrics + Quiz
**Screen 1 - Song Video with Lyrics:**
- TOP 60%: Video placeholder (9:16 aspect ratio, rounded corners, play button overlay)
- BOTTOM 40%: Scrollable lyrics with current line highlighted (bold/colored)
- Bottom button: "Take Quiz"

**Screen 2 - Quiz:**
- 3 hardcoded multiple-choice questions
- Each question: question text + 3 options (A/B/C)
- Submit button → "You got X/3 correct"

### Test #2: Mini Canary Matching + Profiles
**Screen A - User List:**
- Scrollable feed of 4 fake users
- Each card: name, age, country flag, learning language, profile picture, "Match" button

**Modal Flow:**
- State 1: "Matching..." with spinner (1 second)
- State 2: "Yes! You matched with [Name] 🎉" + "View Profile" button

**Screen B - Profile:**
- User profile details (accessed from modal)

---

## Architecture Decisions

### Project Structure
```
lib/
├── main.dart                    # App entry + routing
├── core/
│   ├── theme/
│   │   └── app_theme.dart      # Centralized theme
│   └── constants/
│       └── app_constants.dart  # Colors, text styles, etc.
├── features/
│   ├── home/
│   │   └── home_screen.dart    # Landing page with 2 test buttons
│   ├── lyrics_quiz/
│   │   ├── screens/
│   │   │   ├── lyrics_screen.dart
│   │   │   └── quiz_screen.dart
│   │   ├── widgets/
│   │   │   ├── video_placeholder.dart
│   │   │   ├── lyrics_display.dart
│   │   │   └── quiz_question_card.dart
│   │   ├── models/
│   │   │   └── question.dart
│   │   └── providers/
│   │       └── quiz_provider.dart
│   └── matching/
│       ├── screens/
│       │   ├── user_list_screen.dart
│       │   └── profile_screen.dart
│       ├── widgets/
│       │   ├── user_card.dart
│       │   └── matching_modal.dart
│       ├── models/
│       │   └── user.dart
│       └── providers/
│           └── matching_provider.dart
```

### State Management
**Choice: Flutter Riverpod**

**Why:**
- Modern, type-safe, compile-time safety
- Better than Provider for slightly complex state (matching modal states)
- Shows awareness of current Flutter best practices
- Easier testing and no BuildContext required
- Industry standard for new Flutter apps

**Alternatives Considered:**
- Provider: Simpler but older pattern
- BLoC: Overkill for this scope
- setState: Too basic, doesn't show architecture skills

### Navigation
**Choice: GoRouter**

**Why:**
- Declarative routing (Flutter recommended)
- Deep linking ready
- Type-safe routes
- Better than Navigator 1.0

### Key Technical Decisions

1. **Feature-Based Architecture**
   - Each test is a separate feature module
   - Promotes scalability and code organization
   - Easy to understand for code walkthrough

2. **Const Constructors**
   - Use throughout for performance
   - Shows understanding of Flutter widget rebuilds

3. **Responsive Design**
   - Use LayoutBuilder and MediaQuery.sizeOf sparingly
   - Prefer Flexible/Expanded widgets

4. **Mock Data**
   - Hardcoded but structured in model classes
   - Simulates real API structure
   - Easy to replace with real API later

5. **Animation Strategy**
   - Test #1: Simple AnimatedContainer for lyrics highlighting
   - Test #2: AnimatedSwitcher for modal states, Hero for profile transition

---

## Loom Video Talking Points

### Introduction (30 sec)
- "Built both tests in one app to show modular architecture"
- "Demonstrates Flutter best practices: feature-based structure, modern state management, clean UI"

### Code Walkthrough (1.5 min)
1. **Project Structure** (30 sec)
   - Show folder structure
   - Explain feature-based organization
   - Point out core/ for shared resources

2. **Test #1 Implementation** (30 sec)
   - Lyrics screen: video placeholder, scrollable lyrics, highlighting logic
   - Quiz screen: Riverpod for state, result calculation

3. **Test #2 Implementation** (30 sec)
   - User list with cards
   - Matching modal with animated state transitions
   - Profile screen navigation

### Technical Highlights (30 sec)
- "Used Riverpod for type-safe state management"
- "GoRouter for navigation"
- "Const constructors for performance"
- "Separated widgets for reusability"

### App Demo (30 sec)
- Quick run-through of both features

---

## Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.1
  go_router: ^14.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

---

## Implementation Notes

### Test #1 Specific
- Lyrics data: List of strings with current index tracking
- Video placeholder: Container with AspectRatio(9/16) + ClipRRect
- Quiz: 3 Question objects with correct answer tracking

### Test #2 Specific
- 4 User objects with: name, age, country, learningLanguage, imageUrl
- Matching delay: Future.delayed(Duration(seconds: 1))
- Modal: showModalBottomSheet with AnimatedSwitcher for states

---

## Git Commit Strategy
- Feature branches or clear atomic commits
- Commit messages: "feat: add lyrics screen", "feat: add matching modal"

---

## Future Improvements (if time permits)
- [ ] Add proper video player integration
- [ ] Animate quiz result reveal
- [ ] Add swipe gestures for user cards
- [ ] Persist quiz results
- [ ] Unit tests for providers

---

**Last Updated:** [Will update as we build]
