import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:librarian_frontend/pages/library_screen/library_screen.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

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

  factory GoogleSignInButtonViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    void _navToIntroScreen(final User user, final BuildContext ctx) {
      Navigator.of(ctx).pushReplacement(
        // TODO(Rob): Implement intro screen
        // MaterialPageRoute(builder: (context) => IntroScreen(user: user)),
        MaterialPageRoute<dynamic>(
          builder: (final BuildContext context) => const LibraryScreen(),
        ),
      );
    }

    void _navToLibraryScreen(final User user, final BuildContext ctx) {
      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute<dynamic>(
          builder: (final BuildContext context) => const LibraryScreen(),
        ),
      );
    }

    return GoogleSignInButtonViewModel(
      usingDarkMode: store.state.userSettings.useDarkMode,
      buttonCaptionStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xFF424242),
        fontWeight: FontWeight.w600,
      ),
      // navToIntroScreen: (user, ctx) => _navToIntroScreen(user, ctx),
      navToIntroScreen: _navToIntroScreen,
      // navToLibraryScreen: (user, ctx) => _navToLibraryScreen(user, ctx),
      navToLibraryScreen: _navToLibraryScreen,
    );
  }
}
