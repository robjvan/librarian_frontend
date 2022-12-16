import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/api/google_books_api.dart';
import 'package:librarian_frontend/middleware/firebase_middleware.dart'
    as firebase;
import 'package:librarian_frontend/middleware/google_books_middleware.dart'
    as gbooks;
import 'package:librarian_frontend/middleware/scanner_middleware.dart'
    as scanner;
import 'package:librarian_frontend/middleware/sort_and_filter_middleware.dart'
    as sort;
import 'package:librarian_frontend/middleware/user_settings_middleware.dart'
    as settings;
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

List<Middleware<GlobalAppState>> buildGlobalAppStateMiddleware(
  final GoogleBooksApi? googleBooksAPI,
) =>
    <Middleware<GlobalAppState>>[
      TypedMiddleware<GlobalAppState, AddBookToCollectionAction>(
        firebase.handleAddBookToFirebaseRequest(),
      ),
      TypedMiddleware<GlobalAppState, RemoveBookFromCollectionAction>(
        firebase.handleDeleteBookRequest(),
      ),
      TypedMiddleware<GlobalAppState, ToggleInFavesListAction>(
        firebase.handleToggleInFavesListRequest(),
      ),
      TypedMiddleware<GlobalAppState, SearchIsbnAction>(
        gbooks.handleSearchIsbnRequest(),
      ),
      TypedMiddleware<GlobalAppState, KeywordSearchAction>(
        gbooks.handleKeywordSearchRequest(),
      ),
      TypedMiddleware<GlobalAppState, ScanIsbnAction>(
        scanner.handleScanISBNRequest(),
      ),
      TypedMiddleware<GlobalAppState, ToggleDarkModeAction>(
        settings.handleToggleDarkModeRequest(),
      ),
      TypedMiddleware<GlobalAppState, ToggleSearchBoxAction>(
        settings.handleToggleSearchModeRequest(),
      ),
      TypedMiddleware<GlobalAppState, ToggleGridViewAction>(
        settings.handleToggleGridViewRequest(),
      ),
      TypedMiddleware<GlobalAppState, ToggleFilterBarAction>(
        settings.handleToggleFilterBarRequest(),
      ),
      TypedMiddleware<GlobalAppState, ChangeSortMethodAction>(
        sort.handleChangeSortMethodRequest(),
      ),
      TypedMiddleware<GlobalAppState, UpdateFilterKeyAction>(
        sort.handleUpdateFilterTermRequest(),
      ),
      TypedMiddleware<GlobalAppState, UpdateSearchTermAction>(
        sort.handleUpdateSearchTermRequest(),
      ),
      TypedMiddleware<GlobalAppState, ToggleResizeModalAction>(
        settings.handleToggleResizeModalRequest(),
      ),
      TypedMiddleware<GlobalAppState, ChangeUserColorAction>(
        settings.handleChangeUserColorRequest(),
      ),
      TypedMiddleware<GlobalAppState, SaveLocalDataAction>(
        settings.handleSaveLocalDataAction(),
      ),
      TypedMiddleware<GlobalAppState, LoadLocalDataAction>(
        settings.handleLoadLocalDataAction(),
      ),
      TypedMiddleware<GlobalAppState, SetGridItemSizeAction>(
        settings.handleUpdateGridItemSizeRequest(),
      ),
    ];
