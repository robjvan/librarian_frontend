import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class BookDetailsScreenViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final Function(dynamic) dispatch;
  final TextStyle unavailableStyle;
  final TextStyle pageCountStyle;

  BookDetailsScreenViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.dispatch,
    required this.unavailableStyle,
    required this.pageCountStyle,
  });

  factory BookDetailsScreenViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;

    Color getTextColor() {
      return _checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor;
    }
    return BookDetailsScreenViewModel(
      canvasColor: _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      textColor: getTextColor(),
      userColor: store.state.userSettings.userColor,
      dispatch: store.dispatch,
      unavailableStyle: TextStyle(
        color: getTextColor().withOpacity(0.6),
        fontStyle: FontStyle.italic,
      ),
      pageCountStyle: TextStyle(
        fontStyle: FontStyle.italic,
        color: getTextColor(),
        fontSize: 16,
      ),
    );
  }
}
