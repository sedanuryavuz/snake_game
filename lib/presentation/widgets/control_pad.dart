import 'package:flutter/material.dart';
import '../../../core/enums/direction.dart';
import '../../../core/logic/snake_engine.dart';

class ControlPad extends StatelessWidget {
  final SnakeEngine engine;
  const ControlPad({super.key, required this.engine});

  Widget _btn(IconData icon, VoidCallback action) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: action,
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade900,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.6),
                offset: const Offset(2, 2),
                blurRadius: 3,
              ),
            ],
          ),
          child: Icon(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _btn(Icons.arrow_upward, () => engine.changeDirection(Direction.up)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _btn(Icons.arrow_back, () => engine.changeDirection(Direction.left)),
              _btn(
                engine.isPaused ? Icons.play_arrow : Icons.pause,
                    () => engine.togglePause(),
              ),
              _btn(Icons.arrow_forward, () => engine.changeDirection(Direction.right)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _btn(Icons.arrow_downward, () => engine.changeDirection(Direction.down)),
            ],
          ),
        ],
      ),
    );
  }
}
