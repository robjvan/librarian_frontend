import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../screens/screens.dart';
import '../../state.dart';

class GoogleSignInButtonViewModel {
  final TextStyle buttonCaptionStyle;
  final bool usingDarkMode;
  final Function(User, BuildContext) navToIntroScreen;
  final Function(User, BuildContext) navToLibraryScreen;

  GoogleSignInButtonViewModel({
    required this.buttonCaptionStyle,
    required this.usingDarkMode,
    required this.navToIntroScreen,
    required this.navToLibraryScreen,
  });

  factory GoogleSignInButtonViewModel.create(Store<GlobalAppState> store) {
    void _navToIntroScreen(User user, BuildContext ctx) {
      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(builder: (context) => IntroScreen(user: user)),
      );
    }

    void _navToLibraryScreen(User user, BuildContext ctx) {
      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(builder: (context) => const LibraryScreen()),
      );
    }

    return GoogleSignInButtonViewModel(
      usingDarkMode: store.state.userSettings.useDarkMode,
      buttonCaptionStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xFF424242),
        fontWeight: FontWeight.w600,
      ),
      navToIntroScreen: (user, ctx) => _navToIntroScreen(user, ctx),
      navToLibraryScreen: (user, ctx) => _navToLibraryScreen(user, ctx),
    );
  }
}
