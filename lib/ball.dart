import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool isGameOver;

  const MyBall({super.key, required this.ballX, required this.ballY, required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Visibility(
        visible: true, // Show the ball only if the game has started
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.deepPurple.withOpacity(0.5), // Adjust the opacity for the glow effect
          child: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.5), // Adjust the shadow color
                    spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // Adjust the shadow offset
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
