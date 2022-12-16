import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:redux/redux.dart';

import '/utilities/authentication.dart';
import '../../state.dart';
import '../widgets.dart';
import 'google_sign_in_button_view_model.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) => StoreConnector(
        distinct: true,
        converter: (Store<GlobalAppState> store) =>
            GoogleSignInButtonViewModel.create(store),
        builder: (context, GoogleSignInButtonViewModel vm) => _isSigningIn
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              )
            : OutlinedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xD58CD9FF)),
                ),
                onPressed: () async {
                  try {
                    setState(() => _isSigningIn = true);
                    User? user =
                        await Authentication.signInWithGoogle(context: context);

                    if (user != null) {
                      DocumentSnapshot doc = await usersRef.doc(user.uid).get();

                      if (!doc.exists) {
                        usersRef.doc(user.uid).set({
                          'id': user.uid,
                          'email': user.email,
                          'photoUrl': user.photoURL,
                          'displayName': user.displayName,
                          'firstRun': true
                        });
                        doc = await usersRef.doc(user.uid).get();
                      }

                      setState(() => _isSigningIn = false);

                      if (doc.get('firstRun') == true) {
                        vm.navToIntroScreen(user, context);
                      } else {
                        vm.navToLibraryScreen(user, context);
                      }
                    } else {
                      setState(() => _isSigningIn = false);
                    }
                  } catch (e) {
                    log('$e');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google_g.png', height: 24),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 16, bottom: 16),
                      child: Text(
                        'google-sign-in-button'.tr,
                        style: vm.buttonCaptionStyle,
                      ),
                    ),
                  ],
                ),
              ),
      );
}
