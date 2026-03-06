import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:snake_game/core/constants/grid.dart';
import '../enums/direction.dart';
import '../enums/game_state.dart';

class SnakeEngine {
  final Random _rnd = Random();

  late List<Point<int>> snake;
  late Point<int> food;
  late Direction direction;

  GameState state = GameState.gameOver;

  int score = 0;
  int lastScore = 0;
  int highScore = 0;
  int speedMillis = 200;

  Timer? _timer;

  VoidCallback? onUpdate;

  SnakeEngine() {
    snake = [const Point(0, 0)];
    food = const Point(5, 5);
    direction = Direction.right;
  }

  bool get isGameOver => state == GameState.gameOver;
  bool get isPaused => state == GameState.paused;
  bool get isPlaying => state == GameState.playing;

  void startGame() {
    _timer?.cancel();
    
    speedMillis = 200;
    lastScore = score;
    if (score > highScore) {
      highScore = score;
    }
    score = 0;

    snake = List.generate(
      Grid.initialSnakeLength,
      (i) => Point(
        Grid.initialSnakeLength - i - 1,
        0,
      ),
    );
    direction = Direction.right;
    
    _placeFood();

    state = GameState.playing;

    _timer = Timer.periodic(
      Duration(milliseconds: speedMillis),
      (_) => _tick(),
    );

    onUpdate?.call();
  }

  void _placeFood() {
    while (true) {
      final p = Point(
        _rnd.nextInt(Grid.cols),
        _rnd.nextInt(Grid.rows),
      );
      if (!snake.contains(p)) {
        food = p;
        break;
      }
    }
  }

  void changeDirection(Direction newDir) {
    if (isGameOver) return;

    if (isPaused) {
      togglePause();
    }

    if ((direction == Direction.left && newDir == Direction.right) ||
        (direction == Direction.right && newDir == Direction.left) ||
        (direction == Direction.up && newDir == Direction.down) ||
        (direction == Direction.down && newDir == Direction.up)) {
      return;
    }
    direction = newDir;
    onUpdate?.call();
  }

  void _tick() {
    if (!isPlaying) return;

    final head = snake.first;
    late Point<int> newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    if (newHead.x < 0 ||
        newHead.x >= Grid.cols ||
        newHead.y < 0 ||
        newHead.y >= Grid.rows) {
      _gameOver();
      return;
    }

    if (snake.contains(newHead)) {
      _gameOver();
      return;
    }

    snake = [newHead, ...snake];

    if (newHead == food) {
      score += 10;
      _placeFood();

      if (speedMillis > 60 && score % 50 == 0) {
        speedMillis = (speedMillis * 0.9).toInt();
        _timer?.cancel();
        _timer = Timer.periodic(
          Duration(milliseconds: speedMillis),
          (_) => _tick(),
        );
      }
    } else {
      snake.removeLast();
    }

    onUpdate?.call();
  }

  void _gameOver() {
    lastScore = score;
    if (score > highScore) {
      highScore = score;
    }
    state = GameState.gameOver;
    _timer?.cancel();
    onUpdate?.call();
  }

  void dispose() {
    _timer?.cancel();
  }

  void togglePause() {
    if (isGameOver) return;

    if (isPaused) {
      state = GameState.playing;
      _timer?.cancel();
      _timer = Timer.periodic(
        Duration(milliseconds: speedMillis),
        (_) => _tick(),
      );
    } else {
      state = GameState.paused;
      _timer?.cancel();
    }
    onUpdate?.call();
  }
}
