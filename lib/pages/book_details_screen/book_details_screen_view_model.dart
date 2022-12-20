import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class BookDetailsScreenViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final Function(dynamic) dispatch;

  BookDetailsScreenViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.dispatch,
  });

  factory BookDetailsScreenViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;

    return BookDetailsScreenViewModel(
      canvasColor: _checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      textColor: _checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      userColor: store.state.userSettings.userColor,
      dispatch: store.dispatch,
    );
  }
}
