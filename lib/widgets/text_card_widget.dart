import 'package:flutter/material.dart';
import 'package:space_bombs_app/theme/colors.dart';

class TextCardWidget extends StatelessWidget {
  final String text;
  final Color color;

  const TextCardWidget({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(300))),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
