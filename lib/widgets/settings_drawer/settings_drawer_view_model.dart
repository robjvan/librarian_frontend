import 'package:flutter/material.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class SettingsDrawerViewModel {
  final Function(dynamic) dispatch;
  final Function toggleDarkMode;
  final Color textColor;
  final Color canvasColor;
  final bool isLoading;
  final bool useDarkMode;
  final Color userColor;
  SettingsDrawerViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.isLoading,
    required this.useDarkMode,
    required this.dispatch,
    required this.toggleDarkMode,
  });

  factory SettingsDrawerViewModel.create(Store<GlobalAppState> store) {
    bool _checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return SettingsDrawerViewModel(
      useDarkMode: _checkDarkMode(),
      userColor: store.state.userSettings.userColor,
      isLoading: store.state.loadingStatus == LoadingStatus.loading,
      canvasColor: _checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      textColor: _checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      dispatch: (action) => store.dispatch(action),
      toggleDarkMode: () => store.dispatch(ToggleDarkModeAction()),
    );
  }
}
