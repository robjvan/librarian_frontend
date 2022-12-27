import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';
import 'package:redux/redux.dart';

@immutable
class ForgotPasswordScreenViewModel {
  // final TextStyle titleStyle;
  // final TextStyle subheaderStyle;
  final Function(
    GlobalKey<FormState> formKey,
    String email,
    BuildContext context,
  ) submitFn;

  const ForgotPasswordScreenViewModel({
    required this.submitFn,
    //   required this.titleStyle,
    //   required this.subheaderStyle,
  });

  factory ForgotPasswordScreenViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    void submitFn(
      final GlobalKey<FormState> formKey,
      final String emailAddress,
      final BuildContext context,
    ) {
      if (formKey.currentState!.validate()) {
        AuthService.sendPasswordResetEmail(
          emailAddress,
          context,
        );
      }
    }

    return ForgotPasswordScreenViewModel(
      // titleStyle: loginHeaderStyle,
      // subheaderStyle: loginSubheaderStyle,
      submitFn: submitFn,
    );
  }
}
