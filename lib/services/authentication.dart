import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:librarian_frontend/pages/pages.dart';

class AuthService {
  // this method initializes the Firebase App
  static Future<FirebaseApp> initializeFirebase({
    required final BuildContext context,
  }) async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();

    // attempt auto-login
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Get.offAll(() => const LibraryScreen());
    }

    return firebaseApp;
  }

  static dynamic customSnackBar({
    required final String type,
    required final String content,
  }) {
    String title = '';
    late IconData icon;
    switch (type) {
      case 'error':
        title = 'error'.tr;
        icon = Icons.error_outline;
        break;
      case 'success':
        title = 'success'.tr;
        icon = Icons.check_circle_outline;
        break;
    }
    return Get.snackbar(
      title,
      content,
      icon: Icon(icon, color: Colors.red),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // this method is used for Google sign-in
  static Future<User?> signInWithGoogle({
    required final BuildContext context,
  }) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      // if using web platform, sign-in is slightly different
      final GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);
        user = userCredential.user;
        return user;
      } on Exception catch (e) {
        log('$e');
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle account-already-exists error here
            AuthService.customSnackBar(
              type: 'error',
              content:
                  'The account already exists with a different credential.',
            );
          } else if (e.code == 'invalid-credential') {
            // handle invalid-credential error here
            AuthService.customSnackBar(
              type: 'error',
              content: 'Error occurred while accessing credentials. Try again.',
            );
          } else {
            log(e.toString());
          }
        } on Exception {
          // handle generic errors here
          AuthService.customSnackBar(
            type: 'error',
            content: 'Error occurred using Google Sign-In. Try again.',
          );
        }
      }

      // return the authorized user
      return user;
    }
    return null;
  }

  static Future<void> createUserWithEmail(
    final String userEmail,
    final String userPassword,
    final String displayName,
  ) async {
    User? user;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // final UserCredential userCredential =
      //     await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: userEmail,
      //   password: userPassword,
      // );

      // user = userCredential.user;

      // unawaited(user!.sendEmailVerification());

      

      // final DocumentSnapshot<dynamic> doc = await usersRef.doc(user.uid).get();

      // if (!doc.exists) {
      //   unawaited(
      //     usersRef.doc(user.uid).set(<String, dynamic>{
      //       'id': user.uid,
      //       'email': user.email,
      //       'photoUrl': user.photoURL,
      //       'displayName': displayName,
      //       'firstRun': true,
      //     }),
      //   );
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } on Exception catch (e) {
      log('$e');
    }
  }

  static Future<User?> signInWithEmail({
    required final BuildContext context,
    required final String userEmail,
    required final String userPassword,
  }) async {
    User? user;

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      user = userCredential.user;
      
      return user;
      // if (user!.emailVerified) {
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Verify email address before logging in!'),
      //     ),
      //   );
      // }

      // if (!user!.emailVerified) {
      //   // tell user they need to verify email address
      //   // snackbar?
      // } else {
      //   // return the authorized user
      //   return user;
      // }

    } on FirebaseAuthException catch (e) {
      // TODO(Rob): Add snackbar popups for user feedback
      if (e.code == 'invalid-email') {
        log('Improperly formatted email address.'); // TODO(Rob) - Add i18n strings
      } else if (e.code == 'user-not-found') {
        log('No user found for that email.'); // TODO(Rob) - Add i18n strings
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.'); // TODO(Rob) - Add i18n strings
      }
      return null;
    }
  }

  static dynamic sendPasswordResetEmail(final String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      //     .catchError((final dynamic e) {
      //   if (e.code == 'user-not-found' || e.code == 'invalid-email') {
      //     // AuthService.customSnackBar(
      //     //   type: 'error',
      //     //   content: 'login.email-error'.trParams(
      //     //     <String, String>{'email': email},
      //     //   ),
      //     // );
      //   } else if (e.code == 'too-many-requests') {
      //     // AuthService.customSnackBar(
      //     //   type: 'error',
      //     //   content: 'Firebase error - too many requests',
      //     // );
      //   }
      // });
      await Get.defaultDialog(
        title: 'Sent!', // TODO(Rob) - Fix these strings
        content: const Text(
            'An email has been sent to do stuff with things'), // TODO(Rob) - Add i18n strings
        actions: <Widget>[
          ElevatedButton(
            onPressed: Get.back,
            child: Text('ok'.tr),
          ),
        ],
      );
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        AuthService.customSnackBar(
          type: 'error',
          content: 'login.email-error'.trParams(
            <String, String>{'email': email},
          ),
        );
      } else if (e.code == 'too-many-requests') {
        AuthService.customSnackBar(
          type: 'error',
          content:
              'Firebase error - too many requests', // TODO(Rob) - Add i18n strings
        );
      }
    }
  }

  static Future<void> signOut({required final BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } on Exception {
      AuthService.customSnackBar(
        type: 'error', // TODO(Rob) - Add i18n strings
        content:
            'Error signing out. Try again.', // TODO(Rob) - Add i18n strings
      );
    }
  }
}
