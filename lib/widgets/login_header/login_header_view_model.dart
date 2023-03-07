// import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
// import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class LoginHeaderViewModel {
  // final TextStyle titleStyle;
  LoginHeaderViewModel(
      // {
      // required this.titleStyle,
      // }
      );

  factory LoginHeaderViewModel.create(final Store<GlobalAppState> store) {
    return LoginHeaderViewModel(
        // titleStyle: loginHeaderStyle,
        );
  }
}
