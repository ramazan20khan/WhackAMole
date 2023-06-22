import 'package:flutter/material.dart';

class VocabMoleModel {
  String imagePath = "";
  String text = "";
  String soundPath = "";
  VoidCallback? onVisible;
  bool isVisible = false;
  bool isGameCard = false;

  VocabMoleModel({
    required this.imagePath,
    required this.text,
    required this.soundPath,
    this.onVisible,
    this.isVisible = false,
    this.isGameCard = false,
  });
}
