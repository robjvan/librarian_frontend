import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class SearchResultsDialogViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final bool isDarkMode;
  final Function(dynamic) dispatch;

  SearchResultsDialogViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.dispatch,
    required this.isDarkMode,
  });

  factory SearchResultsDialogViewModel.create(
      final Store<GlobalAppState> store) {
    bool checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return SearchResultsDialogViewModel(
      canvasColor: checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      userColor: store.state.userSettings.userColor,
      textColor: checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      dispatch: store.dispatch,
      isDarkMode: store.state.userSettings.useDarkMode,
    );
  }
}
