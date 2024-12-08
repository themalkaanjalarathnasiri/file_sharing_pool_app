
import 'dart:math';
import 'package:flutter/material.dart';

class HomeUtils{
  static Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // Generates a random red component
      random.nextInt(256), // Generates a random green component
      random.nextInt(256), // Generates a random blue component
    );
  }
}