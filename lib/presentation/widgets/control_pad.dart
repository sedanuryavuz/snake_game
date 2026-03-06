import 'package:flutter/material.dart';
import '../../../core/enums/direction.dart';
import '../../../core/logic/snake_engine.dart';

class ControlPad extends StatelessWidget {
  final SnakeEngine engine;
  const ControlPad({super.key, required this.engine});

  Widget _buildArrowBtn(IconData icon, Direction dir) {
    return GestureDetector(
      onTap: () => engine.changeDirection(dir),
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1E1E26),
          border: Border.all(color: Colors.white10, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.8),
              offset: const Offset(4, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(.05),
              offset: const Offset(-2, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Icon(icon, size: 32, color: Colors.greenAccent),
      ),
    );
  }

  Widget _buildCenterBtn() {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF15151D),
         border: Border.all(color: Colors.white10, width: 1),
      ),
      child: const Icon(Icons.circle, size: 16, color: Colors.white24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: _buildArrowBtn(Icons.keyboard_arrow_up_rounded, Direction.up),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: _buildArrowBtn(Icons.keyboard_arrow_left_rounded, Direction.left),
          ),
          Align(
            alignment: Alignment.center,
            child: _buildCenterBtn(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildArrowBtn(Icons.keyboard_arrow_right_rounded, Direction.right),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildArrowBtn(Icons.keyboard_arrow_down_rounded, Direction.down),
          ),
        ],
      ),
    );
  }
}
