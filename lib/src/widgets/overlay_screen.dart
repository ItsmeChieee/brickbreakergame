// lib/src/widgets/overlay_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../brick_breaker.dart';
import 'color_picker_dialog.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.game,
  });

  final String title;
  final String subtitle;
  final BrickBreaker game;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ).animate().slideY(duration: 750.ms, begin: -3, end: 0),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.headlineSmall,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 1.seconds)
              .then()
              .fadeOut(duration: 1.seconds),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ColorPickerDialog(
                  currentColor: game.ballColor.value,
                  onColorSelected: (color) {
                    game.ballColor.value = color;
                  },
                ),
              );
            },
            child: const Text(
              'CUSTOMIZE BALL',
              style: TextStyle(
                fontSize: 20, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Makes the text bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
