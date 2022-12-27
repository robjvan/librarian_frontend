import 'package:flutter/material.dart';
import 'package:librarian_frontend/actions/actions.dart';
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
  // final Function testLoadingStatus;
  final String searchTerm;
  final bool filterBarVisible;

  const LibraryScreenViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.isLoading,
    required this.useDarkMode,
    required this.dispatch,
    // required this.testLoadingStatus,
    required this.searchTerm,
    required this.filterBarVisible,
  });

  factory LibraryScreenViewModel.create(final Store<GlobalAppState> store) {
    bool _checkDarkMode() => store.state.userSettings.useDarkMode;

    // Future<void> _testLoadingStatus() async {
    //   store.dispatch(const SetLoadingStatusAction(LoadingStatus.loading));
    //   await Future<dynamic>.delayed(const Duration(seconds: 1));
    //   store.dispatch(const SetLoadingStatusAction(LoadingStatus.idle));
    // }

    return LibraryScreenViewModel(
      useDarkMode: _checkDarkMode(),
      isLoading: store.state.loadingStatus == LoadingStatus.loading,
      canvasColor: _checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      textColor: _checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      dispatch: store.dispatch,
      // testLoadingStatus: _testLoadingStatus,
      searchTerm: store.state.userSettings.searchTerm,
      filterBarVisible: store.state.userSettings.filterBarVisible,
    );
  }
}
