import 'package:flutter/material.dart';

/// Global App theme
/// Holds colors and styles

const double cardMargin = 24;

const Color lightModeTextColor = darkGrey;
const Color lightModeBgColor = white;
const Color lightModeCardColor = Color(0xFFAAAAAA);

const Color darkModeTextColor = white;
const Color darkModeBgColor = darkGrey;
const Color darkModeCardColor = Color(0xFF000000);

// Text Styles
const TextStyle titleHeaderStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  fontFamily: Fonts.carroisSC,
  letterSpacing: 1.5,
);
const TextStyle bodyTextStyle = TextStyle();
const TextStyle bodyHeaderTextStyle = TextStyle();
const TextStyle bookTitleStyle = TextStyle(
  fontSize: 24,
  fontFamily: Fonts.carroisSC,
  fontWeight: FontWeight.bold,
);
const TextStyle bookAuthorStyle =
    TextStyle(fontSize: 18, fontFamily: Fonts.carroisSC);

// Colors
const Color white = Color(0xFFFFFFFF);
const Color black = Color(0xFF000000);
const Color green = Color(0xFF4CAF50);
const Color blue = Color(0xFF0000FF);
const Color red = Color(0xFFFF0000);
const Color grey = Color(0xFF808080);
const Color lightGrey = Color(0xFFDDDDDD);
const Color darkGrey = Color(0xFF212121);

class Fonts {
  static const String carroisSC = 'CarroisSC';
  static const String montserrat = 'Montserrat';
}
