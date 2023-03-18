import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class ErrorDialogViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;

  ErrorDialogViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
  });

  factory ErrorDialogViewModel.create(final Store<GlobalAppState> store) {
    bool checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return ErrorDialogViewModel(
      textColor: checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor,
      canvasColor: checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      userColor: store.state.userSettings.userColor,
    );
  }
}
