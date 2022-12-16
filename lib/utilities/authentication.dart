import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:librarian_frontend/pages/pages.dart';

import '../pages/library_screen/library_screen.dart';

class Authentication {
  // this method initializes the Firebase App
  static Future<FirebaseApp> initializeFirebase({
    required final BuildContext context,
  }) async {
    final FirebaseApp firebaseApp = await Firebase.initializeApp();

    // attempt auto-login
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<dynamic>(
          builder: (final BuildContext context) => const LibraryScreen(),
        ),
      );
    }

    return firebaseApp;
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
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential.',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            // handle invalid-credential error here
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          } else {
            log(e.toString());
          }
        } on Exception {
          // handle generic errors here
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign-In. Try again.',
            ),
          );
        }
      }

      // return the authorized user
      return user;
    }
    return null;
  }

  static Future<void> createUserWithEmail({
    required final String userEmail,
    required final String userPassword,
    required final String displayName,
  }) async {
    User? user;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      user = userCredential.user;

      unawaited(user!.sendEmailVerification());

      final DocumentSnapshot<dynamic> doc = await usersRef.doc(user.uid).get();

      if (!doc.exists) {
        unawaited(
          usersRef.doc(user.uid).set(<String, dynamic>{
            'id': user.uid,
            'email': user.email,
            'photoUrl': user.photoURL,
            'displayName': displayName,
            'firstRun': true,
          }),
        );
      }
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
      // log(userEmail);
      // log(userPassword);
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      user = userCredential.user;
      // log(user);
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
      // log(e);
      if (e.code == 'invalid-email') {
        log('Improperly formatted email address.');
      } else if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
      return null;
    }
  }

  static SnackBar customSnackBar({required final String content}) => SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          content,
          style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
        ),
      );

  static Future<void> signOut({required final BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(content: 'Error signing out. Try again.'),
      );
    }
  }
}
