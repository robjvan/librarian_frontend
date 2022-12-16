import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

@immutable
class LoginScreenViewModel {
  final TextStyle titleStyle;
  final TextStyle passwordButtonStyle;
  final TextStyle createAccountButtonStyle;

  const LoginScreenViewModel({
    required this.titleStyle,
    required this.passwordButtonStyle,
    required this.createAccountButtonStyle,
  });

  factory LoginScreenViewModel.create(final Store<GlobalAppState> store) =>
      const LoginScreenViewModel(
        titleStyle: TextStyle(
          fontFamily: 'CarroisSC',
          fontSize: 64,
          fontWeight: FontWeight.w600,
          color: Color(0xFFFFFFFF),
        ),
        passwordButtonStyle: TextStyle(
          color: Color(0xFF424242),
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
        createAccountButtonStyle: TextStyle(
          color: Color(0xFF424242),
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      );
}
