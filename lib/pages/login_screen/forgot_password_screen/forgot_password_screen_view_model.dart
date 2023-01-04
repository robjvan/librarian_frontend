import 'package:flutter/material.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';
import 'package:redux/redux.dart';

@immutable
class ForgotPasswordScreenViewModel {
  final TextStyle blurbStyle;
  final Function(
    GlobalKey<FormState> formKey,
    String email,
    BuildContext context,
  ) submitFn;

  const ForgotPasswordScreenViewModel({
    required this.submitFn,
    required this.blurbStyle,
  });

  factory ForgotPasswordScreenViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    Future<void> submitFn(
      final GlobalKey<FormState> formKey,
      final String emailAddress,
      final BuildContext context,
    ) async {
      if (formKey.currentState!.validate()) {
        await AuthService.sendPasswordResetEmail(emailAddress);
      }
    }

    return ForgotPasswordScreenViewModel(
      blurbStyle: const TextStyle(
        fontSize: 18,
      ),
      submitFn: submitFn,
    );
  }
}
