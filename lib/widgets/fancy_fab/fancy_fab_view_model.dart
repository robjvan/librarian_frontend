import 'package:flutter/material.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class FancyFABViewModel {
  final Function(dynamic) dispatch;
  final Color textColor;
  final Color canvasColor;
  final bool isLoading;
  final bool useDarkMode;
  final Color userColor;

  FancyFABViewModel({
    required this.textColor,
    required this.userColor,
    required this.canvasColor,
    required this.isLoading,
    required this.useDarkMode,
    required this.dispatch,
  });

  factory FancyFABViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return FancyFABViewModel(
      useDarkMode: _checkDarkMode(),
      userColor: store.state.userSettings.userColor,
      isLoading: store.state.loadingStatus == LoadingStatus.loading,
      canvasColor: _checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      textColor: _checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      dispatch: store.dispatch,
    );
  }
}
