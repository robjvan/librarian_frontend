import 'package:flutter/material.dart';
import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

Middleware<GlobalAppState> handleToggleDarkModeRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings
              .copyWith(useDarkMode: !store.state.userSettings.useDarkMode),
        ),
      );
      store.dispatch(
        SaveLocalDataAction(
          store.state.userSettings
              .copyWith(useDarkMode: store.state.userSettings.useDarkMode),
        ),
      );
    };

Middleware<GlobalAppState> handleToggleGridViewRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings
              .copyWith(useGridView: !store.state.userSettings.useGridView),
        ),
      );
      store.dispatch(
        SaveLocalDataAction(
          store.state.userSettings
              .copyWith(useGridView: store.state.userSettings.useGridView),
        ),
      );
    };

Middleware<GlobalAppState> handleToggleSearchModeRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(
            searchBoxVisible: !store.state.userSettings.searchBoxVisible,
          ),
        ),
      );
      store.dispatch(
        SaveLocalDataAction(
          store.state.userSettings.copyWith(
            searchBoxVisible: store.state.userSettings.searchBoxVisible,
          ),
        ),
      );
    };

Middleware<GlobalAppState> handleToggleFilterBarRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(
            filterBarVisible: !store.state.userSettings.filterBarVisible,
          ),
        ),
      );
      store.dispatch(
        SaveLocalDataAction(
          store.state.userSettings.copyWith(
            filterBarVisible: store.state.userSettings.filterBarVisible,
          ),
        ),
      );
    };

Middleware<GlobalAppState> handleToggleResizeModalRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(
            resizeModalVisible: !store.state.userSettings.resizeModalVisible,
          ),
        ),
      );
    };

Middleware<GlobalAppState> handleUpdateGridItemSizeRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        SaveLocalDataAction(
          store.state.userSettings.copyWith(gridItemSize: action.gridItemSize),
        ),
      );
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(gridItemSize: action.gridItemSize),
        ),
      );
    };

Middleware<GlobalAppState> handleChangeUserColorRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(userColor: action.color),
        ),
      );
      store.dispatch(
        SaveLocalDataAction(
          store.state.userSettings.copyWith(userColor: action.color),
        ),
      );
    };

Middleware<GlobalAppState> handleSaveLocalDataAction() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool('useDarkmode', action.userSettings.useDarkMode);
      await prefs.setBool('useGridView', action.userSettings.useGridView);
      await prefs.setString(
        'userColor',
        action.userSettings.userColor.toString().contains('MaterialColor')
            ? action.userSettings.userColor.toString().substring(35, 45)
            : action.userSettings.userColor.toString().substring(6, 16),
      );
      await prefs.setDouble('gridItemSize', action.userSettings.gridItemSize!);
    };

Middleware<GlobalAppState> handleLoadLocalDataAction() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final double? gridItemSize = prefs.containsKey('gridItemSize')
          ? prefs.getDouble('gridItemSize')
          : 100;
      final bool? useDarkMode = prefs.containsKey('useDarkmode')
          ? prefs.getBool('useDarkmode')
          : false;
      final bool? useGridView = prefs.containsKey('useGridView')
          ? prefs.getBool('useGridView')
          : true;
      final Color userColor = prefs.containsKey('userColor')
          ? Color(int.parse(prefs.getString('userColor')!))
          : AppColors.green;

      final SettingsStateRepository settings =
          SettingsStateRepository.createEmpty().copyWith(
        filterBarVisible: false,
        gridItemSize: gridItemSize,
        searchBoxVisible: false,
        searchTerm: '',
        useDarkMode: useDarkMode,
        useGridView: useGridView,
        userColor: userColor,
      );
      store.dispatch(UpdateUserSettingsAction(settings));
    };
