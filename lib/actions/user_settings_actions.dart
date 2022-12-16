import 'package:flutter/material.dart';
import 'package:librarian_frontend/models/models.dart';

/// Reducer for changes in the user settings
class UpdateUserSettingsAction {
  final SettingsStateRepository userSettings;
  const UpdateUserSettingsAction(this.userSettings);

  @override
  String toString() => 'UpdateUserSettingsAction{userSettings: $userSettings}';
}

/// Toggle dark theme
class ToggleDarkModeAction {}

/// Toggle grid view
class ToggleGridViewAction {}

/// Toggle "search mode", this will show the search bar
class ToggleSearchBoxAction {}

/// Change the sorting method used in the collection view
class ChangeSortMethodAction {
  final SortMethod? sortMethod;
  const ChangeSortMethodAction(this.sortMethod);

  @override
  String toString() => 'ChangeSortMethodAction{sortMethod: $sortMethod}';
}

/// Change the accent color used throughout the app
class ChangeUserColorAction {
  final Color color;
  const ChangeUserColorAction(this.color);

  @override
  String toString() => 'ChangeUserColorAction{color: $color}';
}

/// Save local data
class SaveLocalDataAction {
  final SettingsStateRepository userSettings;
  const SaveLocalDataAction(this.userSettings);

  @override
  String toString() => 'SaveLocalDataAction{userSettings: $userSettings}';
}

/// Load local data
class LoadLocalDataAction {}

/// Set the grid item size
class SetGridItemSizeAction {
  final double gridItemSize;
  const SetGridItemSizeAction(this.gridItemSize);

  @override
  String toString() => 'SetGridItemSizeAction{gridItemSize: $gridItemSize}';
}
