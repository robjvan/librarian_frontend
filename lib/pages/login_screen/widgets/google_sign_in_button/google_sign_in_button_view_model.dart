
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

class GoogleSignInButtonViewModel {
  final TextStyle buttonCaptionStyle;
  final bool usingDarkMode;
  final Function navToIntroScreen;
  final Function navToLibraryScreen;

  GoogleSignInButtonViewModel({
    required this.buttonCaptionStyle,
    required this.usingDarkMode,
    required this.navToIntroScreen,
    required this.navToLibraryScreen,
  });

  factory GoogleSignInButtonViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    void _navToIntroScreen() {
      Get.offAll(() => const IntroScreen());
    }

    void _navToLibraryScreen() => Get.offAll(() => const LibraryScreen());

    return GoogleSignInButtonViewModel(
      usingDarkMode: store.state.userSettings.useDarkMode,
      buttonCaptionStyle: const TextStyle(
        fontSize: 20,
        color: Color(0xFF424242),
        fontWeight: FontWeight.w600,
      ),
      navToIntroScreen: _navToIntroScreen,
      navToLibraryScreen: _navToLibraryScreen,
    );
  }
}
