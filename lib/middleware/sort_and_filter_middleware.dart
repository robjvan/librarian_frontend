import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

Middleware<GlobalAppState> handleUpdateSearchTermRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(searchTerm: action.searchTerm),
        ),
      );
    };

Middleware<GlobalAppState> handleUpdateFilterTermRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(filterKey: action.filterKey),
        ),
      );
    };

Middleware<GlobalAppState> handleChangeSortMethodRequest() => (
      final Store<GlobalAppState> store,
      final dynamic action,
      final dynamic next,
    ) {
      store.dispatch(
        UpdateUserSettingsAction(
          store.state.userSettings.copyWith(sortMethod: action.sortMethod),
        ),
      );
    };
