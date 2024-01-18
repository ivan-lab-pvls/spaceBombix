import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:space_bombs_app/models/card_model.dart';
import 'package:space_bombs_app/theme/colors.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({
    required this.card,
    required this.index,
    required this.onCardPressed,
    super.key,
  });

  final CardModel card;
  final int index;
  final ValueChanged<int> onCardPressed;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {

  @override
  void initState() {
    super.initState();
  }

  void _handleCardTap() {
    if (widget.card.state == CardState.hidden) {
      Timer(const Duration(milliseconds: 100), () {
        widget.onCardPressed(widget.index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCardTap,
      child: Center(
          child: widget.card.state == CardState.hidden
              ? Container(
                  width: 80,
                  height: 85,
                  decoration: BoxDecoration(
                      color: AppColors.black,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Center(
                    child: Image.asset(
                      'assets/images/game/close-card.png',
                      width: 60,
                    ),
                  ),
                )
              : Container(
                  width: 80,
                  height: 85,
                  decoration: BoxDecoration(
                      color: widget.card.image != 'assets/images/game/bomb.png'
                          ? AppColors.black
                          : AppColors.blue,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Center(
                      child: Image.asset(
                    widget.card.image,
                    width: 60,
                  )),
                )),
    );
  }
}
