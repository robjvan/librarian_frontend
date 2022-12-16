import 'package:librarian_frontend/models/models.dart';

class UpdateSearchTermAction {
  final String searchTerm;
  const UpdateSearchTermAction(this.searchTerm);

  @override
  String toString() => 'UpdateSearchTermAction{searchTerm: $searchTerm}';
}

class UpdateFilterKeyAction {
  final FilterKey? filterKey;
  const UpdateFilterKeyAction(this.filterKey);

  @override
  String toString() => 'UpdateFilterKeyAction{filterKey: $filterKey}';
}

/// Toggle filter bar visibility
class ToggleFilterBarAction {}

/// Toggle grid item resize modal visibility
class ToggleResizeModalAction {}
