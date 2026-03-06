import 'dart:math';
import 'dart:ui';
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
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      engine.startGame();
    });
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

  Widget _buildScoreCard(String label, int value, Color glowColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF15151D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: glowColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString().padLeft(4, '0'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    if (engine.isPlaying) return const SizedBox.shrink();

    final isGameOver = engine.isGameOver;
    final title = isGameOver ? "GAME OVER" : "PAUSED";
    final btnText = isGameOver ? "PLAY AGAIN" : "RESUME";
    final mainColor = isGameOver ? Colors.redAccent : Colors.orangeAccent;

    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: mainColor,
                    shadows: [
                      Shadow(color: mainColor.withOpacity(0.8), blurRadius: 15),
                    ],
                  ),
                ),
                if (isGameOver && engine.score > 0) ...[
                  const SizedBox(height: 10),
                  Text(
                    "SCORE: ${engine.lastScore}",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: isGameOver ? engine.startGame : engine.togglePause,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: mainColor, width: 2),
                      boxShadow: [
                        BoxShadow(color: mainColor.withOpacity(0.4), blurRadius: 12),
                      ],
                    ),
                    child: Text(
                      btnText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PIXEL SNAKE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: [Shadow(color: Colors.greenAccent, blurRadius: 8)],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(engine.isPaused ? Icons.play_arrow : Icons.pause),
            color: Colors.white,
            onPressed: engine.togglePause,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final size = min(constraints.maxWidth - 32, availableHeight - 320);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildScoreCard("SCORE", engine.score, Colors.greenAccent),
                      _buildScoreCard("HIGH SCORE", engine.highScore, Colors.amberAccent),
                    ],
                  ),
                  
                  GestureDetector(
                    onVerticalDragUpdate: _onVerticalDrag,
                    onHorizontalDragUpdate: _onHorizontalDrag,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: const Color(0xFF08080A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.3), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: CustomPaint(
                              size: Size.square(size),
                              painter: SnakePainter(
                                snake: engine.snake,
                                food: engine.food,
                              ),
                            ),
                          ),
                          _buildOverlay(),
                        ],
                      ),
                    ),
                  ),
                  
                  ControlPad(engine: engine),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
