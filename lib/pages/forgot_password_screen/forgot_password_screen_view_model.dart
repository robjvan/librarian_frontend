import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

class ForgotPasswordScreenViewModel {
  ForgotPasswordScreenViewModel();

  factory ForgotPasswordScreenViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    return ForgotPasswordScreenViewModel();
  }
}
