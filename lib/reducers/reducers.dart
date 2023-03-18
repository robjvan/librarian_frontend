import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/reducers/data_reducers/loading_status_reducer.dart';
import 'package:librarian_frontend/reducers/data_reducers/settings_state_reducer.dart';
import 'package:librarian_frontend/state.dart';

GlobalAppState globalAppStateReducer(
  final GlobalAppState state,
  final dynamic action,
) =>
    (action is SetGlobalStateAction)
        ? setGlobalStateReducer(state, action)
        : state.copyWith(
            loadingStatus: loadingStatusReducer(state.loadingStatus, action),
            userSettings: settingsStateReducer(state.userSettings, action),
          );

GlobalAppState setGlobalStateReducer(
  final GlobalAppState state,
  final SetGlobalStateAction action,
) =>
    action.state;
