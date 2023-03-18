import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class ExitDialogViewModel {
  final Color textColor;
  final Color canvasColor;

  ExitDialogViewModel({
    required this.textColor,
    required this.canvasColor,
  });

  factory ExitDialogViewModel.create(final Store<GlobalAppState> store) {
    bool checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return ExitDialogViewModel(
      textColor: checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor,
      canvasColor: checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
    );
  }
}
