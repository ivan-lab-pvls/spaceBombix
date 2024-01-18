import 'package:flutter/material.dart';
import 'package:space_bombs_app/theme/colors.dart';

class ActionButtonWidget extends StatefulWidget {
  final String text;
  final Color color;
  final double borderRadius;
  final void Function()? onTap;

  const ActionButtonWidget(
      {super.key,
      required this.text,
      required this.color,
      required this.borderRadius,
      required this.onTap});

  @override
  State<ActionButtonWidget> createState() => _ActionButtonWidgetState();
}

class _ActionButtonWidgetState extends State<ActionButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 240,
        height: 50,
        decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: Colors.transparent),
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius))),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
