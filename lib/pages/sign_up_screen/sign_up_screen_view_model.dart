import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/login_screen/login_screen.dart';
import 'package:librarian_frontend/services/authentication.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

@immutable
class SignUpScreenViewModel {
  final Function({
    required String displayName,
    required String email,
    required String password,
  }) submitFn;

  const SignUpScreenViewModel({
    required this.submitFn,
  });

  factory SignUpScreenViewModel.create(final Store<GlobalAppState> store) {
    Color getTextColor() {
      return store.state.userSettings.useDarkMode
          ? AppColors.darkModeTextColor
          : AppColors.lightModeTextColor;
    }

    dynamic createNewUser({
      required final String displayName,
      required final String email,
      required final String password,
    }) async {
      await AuthService.createUserWithEmail(email, password, displayName);

      // // Pop up a dialog stating to check for validation email
      // unawaited(
      //   Get.dialog(
      //     AlertDialog(
      //       title: Text('register.verification-sent'.tr),
      //       titleTextStyle: TextStyle(color: getTextColor()),
      //       content: Text(
      //         'register.verify-email-blurb'.tr,
      //         style: TextStyle(color: getTextColor()),
      //       ),
      //       actions: [
      //         ElevatedButton(
      //           onPressed: Get.back,
      //           child: Text('ok'.tr),
      //         ),
      //       ],
      //     ),
      //   ),
      // );

      // Route user back to the login screen
      unawaited(Get.offAll(() => const LoginScreen()));
    }

    return SignUpScreenViewModel(
      submitFn: createNewUser,
    );
  }
}
