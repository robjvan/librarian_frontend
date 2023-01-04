import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class NewBookScreenViewModel {
  final Color textColor;
  final Color canvasColor;
  final Color userColor;
  final Function(dynamic) dispatch;
  final TextStyle titleStyle;

  NewBookScreenViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.userColor,
    required this.dispatch,
    required this.titleStyle,
  });

  factory NewBookScreenViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;
    Color _getTextColor() => _checkDarkMode()
        ? AppColors.darkModeTextColor
        : AppColors.lightModeTextColor;
    return NewBookScreenViewModel(
      canvasColor: _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      textColor: _getTextColor(),
      userColor: store.state.userSettings.userColor,
      dispatch: store.dispatch,
      titleStyle: TextStyle(
        color: _getTextColor(),
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
