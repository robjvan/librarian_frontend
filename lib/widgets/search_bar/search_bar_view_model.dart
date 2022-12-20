import 'package:flutter/material.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class SearchBarViewModel {
  final Function(dynamic) dispatch;
  final Function(String) updateSearchTerm;
  final Function(TextEditingController) clearSearchTerm;
  final Function toggleSearchBox;
  final Function toggleFilterBar;
  final Function toggleGridView;
  final Function toggleResizeModal;
  final Color textColor;
  final Color canvasColor;
  final bool isLoading;
  final bool useDarkMode;
  final bool searchBoxVisible;
  final bool useGridView;
  final bool filterBarVisible;
  final bool resizeModalVisible;
  final Color userColor;
  final double? gridItemSize;

  SearchBarViewModel({
    required this.textColor,
    required this.canvasColor,
    required this.isLoading,
    required this.useDarkMode,
    required this.searchBoxVisible,
    required this.useGridView,
    required this.dispatch,
    required this.toggleSearchBox,
    required this.toggleGridView,
    required this.toggleFilterBar,
    required this.toggleResizeModal,
    required this.updateSearchTerm,
    required this.clearSearchTerm,
    required this.filterBarVisible,
    required this.resizeModalVisible,
    required this.userColor,
    required this.gridItemSize,
  });

  factory SearchBarViewModel.create(Store<GlobalAppState> store) {
    bool _checkDarkMode() {
      return store.state.userSettings.useDarkMode;
    }

    return SearchBarViewModel(
      dispatch: (action) => store.dispatch(action),
      userColor: store.state.userSettings.userColor,
      canvasColor: _checkDarkMode() ? darkModeBgColor : lightModeBgColor,
      textColor: _checkDarkMode() ? darkModeTextColor : lightModeTextColor,
      isLoading: store.state.loadingStatus == LoadingStatus.loading,
      useDarkMode: _checkDarkMode(),
      useGridView: store.state.userSettings.useGridView,
      searchBoxVisible: store.state.userSettings.searchBoxVisible,
      toggleGridView: () => store.dispatch(ToggleGridViewAction()),
      toggleFilterBar: () => store.dispatch(ToggleFilterBarAction()),
      toggleSearchBox: () => store.dispatch(ToggleSearchBoxAction()),
      updateSearchTerm: (searchTerm) =>
          store.dispatch(UpdateSearchTermAction(searchTerm)),
      clearSearchTerm: (controller) {
        controller.clear();
        store.dispatch(const UpdateSearchTermAction(''));
      },
      filterBarVisible: store.state.userSettings.filterBarVisible,
      resizeModalVisible: store.state.userSettings.resizeModalVisible,
      toggleResizeModal: () => store.dispatch(ToggleResizeModalAction()),
      gridItemSize: store.state.userSettings.gridItemSize,
    );
  }
}
