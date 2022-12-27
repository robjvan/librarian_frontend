import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:redux/redux.dart';

class GoogleSignInButtonViewModel {
  final TextStyle buttonCaptionStyle;
  final Function navToIntroScreen;
  final Function navToLibraryScreen;
  final Function(BuildContext context) signInWithGoogle;

  GoogleSignInButtonViewModel({
    required this.buttonCaptionStyle,
    required this.navToIntroScreen,
    required this.navToLibraryScreen,
    required this.signInWithGoogle,
  });

  factory GoogleSignInButtonViewModel.create(
    final Store<GlobalAppState> store,
  ) {
    void _navToIntroScreen() => Get.offAll(() => const IntroScreen());

    void _navToLibraryScreen() => Get.offAll(() => const LibraryScreen());

    Future<void> signInWithGoogle(final BuildContext context) async {
      try {
        final User? user = await AuthService.signInWithGoogle(
          context: context,
        );

        if (user != null) {
          DocumentSnapshot<dynamic> doc = await usersRef.doc(user.uid).get();

          if (!doc.exists) {
            await usersRef.doc(user.uid).set(
              <String, dynamic>{
                'id': user.uid,
                'email': user.email,
                'photoUrl': user.photoURL,
                'displayName': user.displayName,
                'firstRun': true
              },
            );
            doc = await usersRef.doc(user.uid).get();
          }

          if (doc.get('firstRun') == true) {
            _navToIntroScreen();
          } else {
            _navToLibraryScreen();
          }
        }
      } on Exception catch (e) {
        if (kDebugMode) {
          // ignore: avoid_print
          print(e);
        }
      }
    }

    return GoogleSignInButtonViewModel(
      buttonCaptionStyle: AppTextStyles.googleSignInButtonStyle,
      navToIntroScreen: _navToIntroScreen,
      navToLibraryScreen: _navToLibraryScreen,
      signInWithGoogle: signInWithGoogle,
    );
  }
}
