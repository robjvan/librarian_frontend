import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:redux/redux.dart';

Reducer<SettingsStateRepository> settingsStateReducer =
    TypedReducer<SettingsStateRepository, UpdateUserSettingsAction>(
  _handleUpdateUserSettingsRequest,
);

SettingsStateRepository _handleUpdateUserSettingsRequest(
  final SettingsStateRepository state,
  final UpdateUserSettingsAction action,
) =>
    state.copyWith(
      sortMethod: action.userSettings.sortMethod,
      useDarkMode: action.userSettings.useDarkMode,
      userColor: action.userSettings.userColor,
      useGridView: action.userSettings.useGridView,
      searchBoxVisible: action.userSettings.searchBoxVisible,
      searchTerm: action.userSettings.searchTerm,
      filterKey: action.userSettings.filterKey,
      gridItemSize: action.userSettings.gridItemSize,
      resizeModalVisible: action.userSettings.resizeModalVisible,
      filterBarVisible: action.userSettings.filterBarVisible,
    );
