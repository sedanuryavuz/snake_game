import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/logic/snake_engine.dart';
import '../../../core/enums/direction.dart';
import '../../../core/painter/snake_painter.dart';
import '../widgets/control_pad.dart';

class SnakePage extends StatefulWidget {
  const SnakePage({super.key});

  @override
  State<SnakePage> createState() => _SnakePageState();
}

class _SnakePageState extends State<SnakePage> {
  late SnakeEngine engine;

  @override
  void initState() {
    super.initState();
    engine = SnakeEngine();
    engine.onUpdate = () => setState(() {});
    engine.startGame();
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    if (details.delta.dy < -5) engine.changeDirection(Direction.up);
    if (details.delta.dy > 5) engine.changeDirection(Direction.down);
  }

  void _onHorizontalDrag(DragUpdateDetails details) {
    if (details.delta.dx < -5) engine.changeDirection(Direction.left);
    if (details.delta.dx > 5) engine.changeDirection(Direction.right);
  }

  @override
  void dispose() {
    engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pixel Snake"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: engine.startGame,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = min(constraints.maxWidth, constraints.maxHeight - 120);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Skor: ${engine.score}", style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              GestureDetector(
                onVerticalDragUpdate: _onVerticalDrag,
                onHorizontalDragUpdate: _onHorizontalDrag,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.grey.shade800, width: 3),
                  ),
                  child: CustomPaint(
                    painter: SnakePainter(
                      snake: engine.snake,
                      food: engine.food,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              engine.isGameOver
                  ? Column(
                children: [
                  const Text("Oyun Bitti", style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: engine.startGame,
                    child: const Text("Tekrar Oyna"),
                  ),
                ],
              )
                  : ControlPad(engine: engine),
              const SizedBox(height: 12),
              const Text("Yön için kaydırın veya butonları kullanın."),
            ],
          );
        },
      ),
    );
  }
}
