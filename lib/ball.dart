import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class MyBall extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool isGameOver;
  final bool hasGameStarted;

  const MyBall({super.key, required this.ballX, required this.ballY, required this.isGameOver, required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted ? Container(
      alignment: Alignment(ballX, ballY),
          child: Container(
            height: 15,
            width: 15,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple,
            ),
          ),
        )
        : Container(
          alignment: Alignment(ballX, ballY),
          child: AvatarGlow(
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastEaseInToSlowEaseOut,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                minRadius: 10,
                maxRadius: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple,
                  ),
                  width: 15,
                  height: 15,
                ),
              ),
            ),
        );
  }
}
