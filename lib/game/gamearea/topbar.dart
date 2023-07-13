import 'package:flutter/material.dart';
import 'package:game/game/colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.skor,
    required this.wrong,
  });

  final int skor;
  final int wrong;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: buildField(context, Icons.star_half_rounded, "$skor",
                TileColors.yellow.color),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: buildField(context, Icons.dangerous_rounded, "$wrong",
                TileColors.red.color),
          )
        ],
      ),
    );
  }

  Container buildField(
      BuildContext context, IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          color: TileColors.background.color,
          borderRadius: BorderRadius.circular(4.0)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: 32, color: color),
          ),
          Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: TileColors.text.color),
            ),
          ),
        ],
      ),
    );
  }
}
