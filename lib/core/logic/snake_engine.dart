import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:snake_game/core/constants/grid.dart';
import '../enums/direction.dart';


class SnakeEngine {
  final Random _rnd = Random();

  late List<Point<int>> snake;
  late Point<int> food;
  late Direction direction;
  bool isGameOver = false;
  int score = 0;
  int speedMillis = 200;

  Timer? _timer;

  VoidCallback? onUpdate;

  void startGame() {
    snake = List.generate(
      Grid.initialSnakeLength,
          (i) => Point(
            Grid.initialSnakeLength - i - 1,
        0,
      ),
    );
    direction = Direction.right;
    score = 0;
    isGameOver = false;
    _placeFood();

    _timer?.cancel();
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
    if ((direction == Direction.left && newDir == Direction.right) ||
        (direction == Direction.right && newDir == Direction.left) ||
        (direction == Direction.up && newDir == Direction.down) ||
        (direction == Direction.down && newDir == Direction.up)) {
      return;
    }
    direction = newDir;
  }

  void _tick() {
    if (isGameOver) return;

    final head = snake.first;
    late Point<int> newHead;

    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, (head.y - 1 + Grid.rows) % Grid.rows);
        break;
      case Direction.down:
        newHead = Point(head.x, (head.y + 1) % Grid.rows);
        break;
      case Direction.left:
        newHead = Point((head.x - 1 + Grid.cols) % Grid.cols, head.y);
        break;
      case Direction.right:
        newHead = Point((head.x + 1) % Grid.cols, head.y);
        break;
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

  void pause() {
    _timer?.cancel();
  }

  void resume() {
    if (!_timerIsActive) {
      _timer = Timer.periodic(
        Duration(milliseconds: speedMillis),
            (_) => _tick(),
      );
    }
  }

  bool get _timerIsActive => _timer?.isActive ?? false;

  void _gameOver() {
    isGameOver = true;
    _timer?.cancel();
    onUpdate?.call();
  }

  void dispose() {
    _timer?.cancel();
  }
}
