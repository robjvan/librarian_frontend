import 'package:flutter/material.dart';

class AppTheme {
  static const double cardMargin = 24;
}

class AppTextStyles {
  static const TextStyle titleHeaderStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.carroisSC,
    letterSpacing: 1.5,
  );
  static const TextStyle bodyTextStyle = TextStyle();
  static const TextStyle bodyHeaderTextStyle = TextStyle();
  static const TextStyle bookTitleStyle = TextStyle(
    fontSize: 24,
    fontFamily: AppFonts.carroisSC,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle bookAuthorStyle =
      TextStyle(fontSize: 18, fontFamily: AppFonts.carroisSC);

  static const TextStyle loginHeaderStyle = TextStyle(
    fontFamily: 'CarroisSC',
    fontSize: 64,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle loginSubheaderStyle = TextStyle(
    // fontFamily: 'CarroisSC',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Color(0xFF424242),
  );

  static const TextStyle googleSignInButtonStyle = TextStyle(
    fontSize: 20,
    color: Color(0xFF424242),
    fontWeight: FontWeight.w600,
  );
}

class AppColors {
  static const Color lightModeTextColor = darkGrey;
  static const Color lightModeBgColor = white;
  static const Color lightModeCardColor = Color(0xFFAAAAAA);

  static const Color darkModeTextColor = white;
  static const Color darkModeBgColor = darkGrey;
  static const Color darkModeCardColor = Color(0xFF000000); // Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color green = Color(0xFF4CAF50);
  static const Color blue = Color(0xFF0000FF);
  static const Color red = Color(0xFFFF0000);
  static const Color grey = Color(0xFF808080);
  static const Color lightGrey = Color(0xFFDDDDDD);
  static const Color darkGrey = Color(0xFF212121);
}

/// Global App theme
/// Holds colors and styles

class AppFonts {
  static const String carroisSC = 'CarroisSC';
  static const String montserrat = 'Montserrat';
}
