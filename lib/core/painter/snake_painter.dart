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
    if (snake.isEmpty) return;
    
    final cellW = size.width / Grid.cols;
    final cellH = size.height / Grid.rows;

    const padding = 1.0;

    final gridPaint = Paint()
      ..color = const Color(0xFF1B1B22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int r = 0; r <= Grid.rows; r++) {
      canvas.drawLine(Offset(0, r * cellH), Offset(size.width, r * cellH), gridPaint);
    }
    for (int c = 0; c <= Grid.cols; c++) {
      canvas.drawLine(Offset(c * cellW, 0), Offset(c * cellW, size.height), gridPaint);
    }

    final foodRect = Rect.fromLTWH(
      food.x * cellW + padding * 2,
      food.y * cellH + padding * 2,
      cellW - padding * 4,
      cellH - padding * 4,
    );

    final foodPaint = Paint()
      ..color = Colors.redAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);

    final foodOutline = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(foodRect.center, foodRect.width / 2, foodPaint);
    canvas.drawCircle(foodRect.center, foodRect.width / 2.5, foodOutline);

    final bodyPaint = Paint()
      ..color = Colors.green.withOpacity(0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2);

    final headPaint = Paint()
      ..color = Colors.greenAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);

    for (int i = 0; i < snake.length; i++) {
      final p = snake[i];
      final rect = Rect.fromLTWH(
        p.x * cellW + padding,
        p.y * cellH + padding,
        cellW - padding * 2,
        cellH - padding * 2,
      );

      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(cellW * 0.3));
      
      if (i == 0) {
        canvas.drawRRect(rrect, headPaint);
         final shine = Rect.fromLTWH(
          rect.left + rect.width * .2,
          rect.top + rect.height * .2,
          rect.width * .3,
          rect.height * .3,
        );
        canvas.drawRect(shine, Paint()..color = Colors.white.withOpacity(0.8));

      } else {
        canvas.drawRRect(rrect, bodyPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SnakePainter oldDelegate) {
    return snake != oldDelegate.snake || food != oldDelegate.food;
  }
}
