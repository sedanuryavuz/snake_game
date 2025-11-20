import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snake_game/core/constants/grid.dart';

class SnakePainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int> food;

  SnakePainter({
    required this.snake,
    required this.food,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final cellW = size.width / Grid.cols;
    final cellH = size.height / Grid.rows;

    const padding = 2.0;

    final gridPaint = Paint()..color = Colors.grey.shade900;
    for (int r = 0; r < Grid.rows; r++) {
      for (int c = 0; c < Grid.cols; c++) {
        final rect = Rect.fromLTWH(c * cellW + .5, r * cellH + .5, cellW - 1, cellH - 1);
        canvas.drawRect(rect, gridPaint);
      }
    }

    for (int i = 0; i < snake.length; i++) {
      final p = snake[i];
      final rect = Rect.fromLTWH(
        p.x * cellW + padding,
        p.y * cellH + padding,
        cellW - padding * 2,
        cellH - padding * 2,
      );

      final rr = RRect.fromRectAndRadius(rect, const Radius.circular(2));
      paint.color = (i == 0) ? Colors.greenAccent : Colors.green;

      canvas.drawRRect(rr, paint);

      final inner = rect.deflate(rect.width * .22);
      paint.color = Colors.black.withOpacity(.12);
      canvas.drawRect(inner, paint);
    }

    final foodRect = Rect.fromLTWH(
      food.x * cellW + padding,
      food.y * cellH + padding,
      cellW - padding * 2,
      cellH - padding * 2,
    );

    paint.color = Colors.redAccent;
    final rr = RRect.fromRectAndRadius(foodRect, const Radius.circular(3));
    canvas.drawRRect(rr, paint);

    final shine = Rect.fromLTWH(
      foodRect.left + foodRect.width * .18,
      foodRect.top + foodRect.height * .18,
      foodRect.width * .3,
      foodRect.height * .3,
    );

    paint.color = Colors.white.withOpacity(.6);
    canvas.drawRect(shine, paint);
  }

  @override
  bool shouldRepaint(covariant SnakePainter oldDelegate) {
    return snake != oldDelegate.snake || food != oldDelegate.food;
  }
}
