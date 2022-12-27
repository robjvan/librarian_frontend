import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class ConfirmDeleteDialogViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final Function(dynamic) dispatch;

  ConfirmDeleteDialogViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.dispatch,
  });

  factory ConfirmDeleteDialogViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;

    return ConfirmDeleteDialogViewModel(
      canvasColor: _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      textColor: _checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor,
      userColor: store.state.userSettings.userColor,
      dispatch: store.dispatch,
    );
  }
}
