import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/services/authentication.dart';
import 'package:librarian_frontend/state.dart';
import 'package:redux/redux.dart';

@immutable
class LoginScreenViewModel {
  final TextStyle titleStyle;
  final TextStyle passwordButtonStyle;
  final TextStyle createAccountButtonStyle;
  final Function(
    BuildContext context,
    String email,
    String password,
  ) signInWithEmail;
  final ButtonStyle emailSigninButtonStyle;

  const LoginScreenViewModel({
    required this.titleStyle,
    required this.passwordButtonStyle,
    required this.createAccountButtonStyle,
    required this.signInWithEmail,
    required this.emailSigninButtonStyle,
  });

  factory LoginScreenViewModel.create(final Store<GlobalAppState> store) {
    Future<void> signInWithEmail(
      final BuildContext context,
      final String email,
      final String password,
    ) async {
      final dynamic user = await AuthService.signInWithEmail(
        context: context,
        userEmail: email,
        userPassword: password,
      );

      if (user.emailVerified) {
        DocumentSnapshot<Object?> doc = await usersRef.doc(user.uid).get();

        if (!doc.exists) {
          await usersRef.doc(user.uid).set(<String, dynamic>{
            'id': user.uid,
            'email': user.email,
            'photoUrl': user.photoURL,
            'displayName': user.displayName,
            'firstRun': true
          });
          doc = await usersRef.doc(user.uid).get();
        }

        if (doc.get('firstRun') == true) {
          unawaited(
            Get.offAll(IntroScreen(user: user)),
          );
        } else {
          unawaited(
            Get.offAll(const LibraryScreen()),
          );
        }
      } else {
        await user?.sendEmailVerification();
        Get.snackbar(
          '',
          'login.verify-email'.tr,
          snackPosition: SnackPosition.TOP,
        );
        await FirebaseAuth.instance.signOut();
      }
    }

    return LoginScreenViewModel(
      titleStyle: const TextStyle(
        fontFamily: 'CarroisSC',
        fontSize: 64,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      passwordButtonStyle: const TextStyle(
        color: Color(0xFF424242),
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
      createAccountButtonStyle: const TextStyle(
        color: Color(0xFF424242),
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
      signInWithEmail: signInWithEmail,
      emailSigninButtonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
