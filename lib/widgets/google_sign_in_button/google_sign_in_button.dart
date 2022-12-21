import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';
import 'package:librarian_frontend/widgets/google_sign_in_button/google_sign_in_button_view_model.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({final Key? key}) : super(key: key);

  @override
  GoogleSignInButtonState createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  @override
  Widget build(final BuildContext context) =>
      StoreConnector<GlobalAppState, GoogleSignInButtonViewModel>(
        distinct: true,
        converter: GoogleSignInButtonViewModel.create,
        builder: (
          final BuildContext context,
          final GoogleSignInButtonViewModel vm,
        ) =>
            _isSigningIn
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
                        final User? user =
                            await Authentication.signInWithGoogle(
                          context: context,
                        );

                        if (user != null) {
                          DocumentSnapshot<dynamic> doc =
                              await usersRef.doc(user.uid).get();

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

                          setState(() => _isSigningIn = false);

                          if (doc.get('firstRun') == true) {
                            // vm.navToIntroScreen(user, context);
                            vm.navToIntroScreen(user);
                          } else {
                            // vm.navToLibraryScreen(user, context);
                            vm.navToLibraryScreen(user);
                          }
                        } else {
                          setState(() => _isSigningIn = false);
                        }
                      } on Exception catch (e) {
                        log('$e');
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/google_g.png', height: 24),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            top: 16,
                            bottom: 16,
                          ),
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
