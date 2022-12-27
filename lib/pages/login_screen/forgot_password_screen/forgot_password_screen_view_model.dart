import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

@immutable
class ForgotPasswordScreenViewModel {
  final TextStyle titleStyle;
  final TextStyle subheaderStyle;

  const ForgotPasswordScreenViewModel({
    required this.titleStyle,
    required this.subheaderStyle,
  });

  factory ForgotPasswordScreenViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    return const ForgotPasswordScreenViewModel(
      titleStyle: TextStyle(
        fontFamily: 'CarroisSC',
        fontSize: 64,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      subheaderStyle: TextStyle(
        // fontFamily: 'CarroisSC',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
    );
  }
}
