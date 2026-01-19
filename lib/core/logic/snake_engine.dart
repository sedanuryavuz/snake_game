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
  bool isPaused = false;

  int score = 0;
  int lastScore = 0;
  int speedMillis = 200;

  Timer? _timer;

  VoidCallback? onUpdate;

  void startGame() {
    _timer?.cancel();
    isGameOver = false;
    isPaused = false;

    speedMillis = 200;
    lastScore = 0;
    score = 0;

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
    if (isGameOver) return;

    if (isPaused) togglePause();

    if ((direction == Direction.left && newDir == Direction.right) ||
        (direction == Direction.right && newDir == Direction.left) ||
        (direction == Direction.up && newDir == Direction.down) ||
        (direction == Direction.down && newDir == Direction.up)) {
      return;
    }
    direction = newDir;
  }

  void _tick() {
    if (isGameOver || isPaused) return;

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
    lastScore = score;
    score = 0;
    isGameOver = true;
    _timer?.cancel();
    onUpdate?.call();
  }

  void dispose() {
    _timer?.cancel();
  }

  void togglePause() {
    if (isGameOver) return;

    if(isPaused){
      _timer?.cancel();
      _timer = Timer.periodic(Duration(milliseconds: speedMillis),
          (_) => _tick(),
      );
      isPaused = false;
    }else{
      _timer?.cancel();
      isPaused = true;
    }
    onUpdate?.call();
  }
}
