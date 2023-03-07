import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

@immutable
class SignUpScreenViewModel {
  final Function submitFn;

  const SignUpScreenViewModel({
    required this.submitFn,
  });

  factory SignUpScreenViewModel.create(final Store<GlobalAppState> store) {
    return SignUpScreenViewModel(
      submitFn: () {
        // store.dispatch(RegisterUserAction());
      },
    );
  }
}
