import 'package:flutter/material.dart';

enum CardState { hidden, visible, guessed }

class CardModel {
  CardModel({
    required this.value,
    required this.image,
    this.state = CardState.hidden,
  });

  final int value;
  final String image;
  CardState state;
}