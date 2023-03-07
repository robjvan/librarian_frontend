import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

@immutable
class SignUpScreenViewModel {
  // final TextStyle blurbStyle;

  const SignUpScreenViewModel(
      // {
      // required this.blurbStyle,
      // }
      );

  factory SignUpScreenViewModel.create(final Store<GlobalAppState> store) {
    return SignUpScreenViewModel(
        // blurbStyle: const TextStyle(fontSize: 18),
        );
  }
}
