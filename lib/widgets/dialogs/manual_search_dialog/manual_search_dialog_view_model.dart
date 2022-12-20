import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class ManualSearchDialogViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final bool isDarkMode;
  final Function(dynamic) dispatch;

  ManualSearchDialogViewModel({
    required this.textColor,
    required this.userColor,
    required this.canvasColor,
    required this.dispatch,
    required this.isDarkMode,
  });

  factory ManualSearchDialogViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    bool _checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return ManualSearchDialogViewModel(
      canvasColor: _checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      userColor: store.state.userSettings.userColor,
      textColor: _checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      dispatch: store.dispatch,
      isDarkMode: store.state.userSettings.useDarkMode,
    );
  }
}
