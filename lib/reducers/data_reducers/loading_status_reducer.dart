import 'package:librarian_frontend/actions/actions.dart';
import 'package:librarian_frontend/models/models.dart';
import 'package:redux/redux.dart';

Reducer<LoadingStatus> loadingStatusReducer =
    TypedReducer<LoadingStatus, SetLoadingStatusAction>(
  _setLoadingStatusReducer,
);

LoadingStatus _setLoadingStatusReducer(
  final LoadingStatus state,
  final SetLoadingStatusAction action,
) =>
    action.loadingStatus;
