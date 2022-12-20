import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class BookGridTileViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final Function(dynamic) dispatch;
  final double gridItemSize;
  // final bool isDarkMode;

  BookGridTileViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.dispatch,
    required this.gridItemSize,
    // @required this.isDarkMode,
  });

  factory BookGridTileViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;

    return BookGridTileViewModel(
      canvasColor: _checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      textColor: _checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      userColor: store.state.userSettings.userColor,
      dispatch: store.dispatch,
      gridItemSize: store.state.userSettings.gridItemSize,
      // isDarkMode: store.state.userSettings.useDarkMode,
    );
  }
}
