import 'package:flutter/material.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

@immutable
class LibraryScreenViewModel {
  final Function(dynamic) dispatch;
  final Color textColor;
  final Color canvasColor;
  final bool isLoading;
  final bool useDarkMode;
  final String searchTerm;
  final bool filterBarVisible;

  const LibraryScreenViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.isLoading,
    required this.useDarkMode,
    required this.dispatch,
    required this.searchTerm,
    required this.filterBarVisible,
  });

  factory LibraryScreenViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;

    return LibraryScreenViewModel(
      useDarkMode: _checkDarkMode(),
      isLoading: store.state.loadingStatus == LoadingStatus.loading,
      canvasColor: _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      textColor: _checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor,
      dispatch: store.dispatch,
      searchTerm: store.state.userSettings.searchTerm,
      filterBarVisible: store.state.userSettings.filterBarVisible,
    );
  }
}
