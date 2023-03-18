import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/widgets/google_sign_in_button/google_sign_in_button_view_model.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({final Key? key}) : super(key: key);

  @override
  GoogleSignInButtonState createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, GoogleSignInButtonViewModel>(
      builder:
          (final BuildContext context, final GoogleSignInButtonViewModel vm) {
        return OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color(0xD58CD9FF),
            ),
          ),
          onPressed: () => vm.signInWithGoogle(context),
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
        );
      },
      converter: GoogleSignInButtonViewModel.create,
      distinct: true,
    );
  }
}
