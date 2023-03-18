import 'package:flutter/material.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class FilterBarViewModel {
  final Function(dynamic) dispatch;
  final Color textColor;
  final Color canvasColor;
  final bool isLoading;
  final bool useDarkMode;
  final bool visibileFilterBar;
  final SortMethod sortMethod;
  final FilterKey filterKey;
  final Color userColor;

  FilterBarViewModel({
    required this.textColor,
    required this.userColor,
    required this.canvasColor,
    required this.isLoading,
    required this.useDarkMode,
    required this.visibileFilterBar,
    required this.dispatch,
    required this.sortMethod,
    required this.filterKey,
  });

  factory FilterBarViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return FilterBarViewModel(
      useDarkMode: _checkDarkMode(),
      userColor: store.state.userSettings.userColor,
      isLoading: store.state.loadingStatus == LoadingStatus.loading,
      canvasColor: _checkDarkMode()
          ? AppColors.darkModeBgColor
          : AppColors.lightModeBgColor,
      textColor: _checkDarkMode()
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor,
      dispatch: store.dispatch,
      visibileFilterBar: store.state.userSettings.filterBarVisible,
      sortMethod: store.state.userSettings.sortMethod,
      filterKey: store.state.userSettings.filterKey,
    );
  }
}
