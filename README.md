# Pixel Snake

A small Flutter arcade game with a neon, retro-inspired presentation. The app renders a 20x20 snake board, supports swipe and on-screen controls, and manages score, pause, speed scaling, and game-over flow in a lightweight game engine.

## Features

- Custom-painted snake board with glowing snake and food effects
- Swipe gestures on the board for directional input
- On-screen control pad for tap-based play
- Pause and resume support
- Score, last score, and session high score tracking
- Speed increases as the score grows

## Tech Stack

- Flutter
- Dart
- CustomPainter for board rendering
- `Timer.periodic` game loop

## Project Structure

```text
lib/
  main.dart                         App entry point and theme setup
  core/
    constants/
      grid.dart                     Board dimensions and initial snake length
    enums/
      direction.dart                Movement directions
      game_state.dart               Playing / paused / game over states
    logic/
      snake_engine.dart             Core game loop and state transitions
    painter/
      snake_painter.dart            Snake, food, and grid rendering
  presentation/
    pages/
      snake_page.dart               Main game screen and layout
    widgets/
      control_pad.dart              On-screen directional controls
test/
  widget_test.dart                  Default Flutter widget test placeholder
```

## How It Works

`SnakeEngine` is the gameplay core. It owns the snake body, food position, direction, score, speed, and current game state. A periodic timer advances the snake, detects collisions, grows the body when food is eaten, and speeds the game up every 50 points.

The UI lives in `presentation/`. `SnakePage` wires the engine into Flutter state updates, renders the score cards and overlays, and forwards user input from drag gestures and the control pad. `SnakePainter` draws the board frame-by-frame from the engine state.

## Getting Started

### Prerequisites

- Flutter SDK installed
- A connected simulator, emulator, or device

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

### Run Static Analysis

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

## Controls

- Swipe up, down, left, or right on the game board
- Or tap the on-screen directional pad
- Use the app bar pause button to pause or resume
- When the game ends, tap `PLAY AGAIN` to restart

## Gameplay Rules

- The snake starts moving automatically
- Eating food increases the score by 10
- The snake speeds up every 50 points
- Hitting a wall ends the run
- Running into the snake body also ends the run
- Direct reversal is blocked, so left cannot immediately become right, and up cannot immediately become down

## Screenshots
