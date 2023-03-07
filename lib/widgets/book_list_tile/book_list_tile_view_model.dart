import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class BookListTileViewModel {
  final Color textColor;
  final Color canvasColor;

  BookListTileViewModel({
    required this.textColor,
    required this.canvasColor,
  });

  factory BookListTileViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return BookListTileViewModel(
      canvasColor: _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      textColor: _checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor,
    );
  }
}
