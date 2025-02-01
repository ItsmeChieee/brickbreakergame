//lib/src/widgets/color_picker_dialog.dart
import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog({
    super.key,
    required this.onColorSelected,
    required this.currentColor,
  });

  final Function(Color) onColorSelected;
  final Color currentColor;

  final List<Color> _colors = const [
    Color(0xff1e6091), // Default blue
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'CHOOSE BALL COLOR',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 24),
      ),
      content: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _colors
            .map(
              (color) => GestureDetector(
                onTap: () {
                  onColorSelected(color);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: color == currentColor
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
