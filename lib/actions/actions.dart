import 'package:librarian_frontend/models/models.dart';
import 'package:librarian_frontend/state.dart';

export './book_collection_actions.dart';
export './sort_and_filter_actions.dart';
export './user_settings_actions.dart';

class SetGlobalStateAction {
  final GlobalAppState state;
  const SetGlobalStateAction(this.state);
}

/// Change loading status
class SetLoadingStatusAction {
  final LoadingStatus loadingStatus;
  const SetLoadingStatusAction(this.loadingStatus);

  @override
  String toString() => 'SetLoadingStatusAction{loadingStatus: $loadingStatus}';
}

/// Scan an ISBN barcode
class ScanIsbnAction {}

/// Search Google Books API using keywords
class KeywordSearchAction {
  final SearchParams searchParams;
  const KeywordSearchAction(this.searchParams);

  @override
  String toString() => 'KeywordSearchAction{searchParams: $searchParams}';
}

// Search Google Books API with ISBN
class SearchIsbnAction {
  final String? isbn;
  const SearchIsbnAction(this.isbn);

  @override
  String toString() => 'SearchIsbnAction{isbn: $isbn}';
}
