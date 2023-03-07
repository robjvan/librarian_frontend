import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

class CollectionViewViewModel {
  final bool useGridView;
  final String searchTerm;
  final FilterKey filterKey;
  final SortMethod sortMethod;
  final double? gridItemSize;

  CollectionViewViewModel({
    required this.useGridView,
    required this.searchTerm,
    required this.filterKey,
    required this.sortMethod,
    required this.gridItemSize,
  });

  factory CollectionViewViewModel.create(final Store<GlobalAppState> store) {
    return CollectionViewViewModel(
      useGridView: store.state.userSettings.useGridView,
      searchTerm: store.state.userSettings.searchTerm,
      filterKey: store.state.userSettings.filterKey,
      sortMethod: store.state.userSettings.sortMethod,
      gridItemSize: store.state.userSettings.gridItemSize,
    );
  }
}
