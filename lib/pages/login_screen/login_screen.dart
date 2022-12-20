import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/login_screen/login_screen_view_model.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';
import 'package:librarian_frontend/widgets/widgets.dart';

final CollectionReference<Map<String, dynamic>> usersRef =
    FirebaseFirestore.instance.collection('users');

class LoginScreen extends StatefulWidget {
  const LoginScreen({final Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPass = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /// Uncomment this line to autofill email credentials
    // emailController.text = 'rob@eastcoastdev.ca';
    // passwordController.text = 'Password1!';
    // tryAutologin();
    emailController.text = 'rob@robjvan.ca';
    passwordController.text = 'Asdf123!';
    super.initState();
  }

  // Future<void> tryAutologin() async {
  //   final User? user = await FirebaseAuth.instance.currentUser;
  //   debugPrint('Current user = $user');

  //   if (user != null) {}
  // }

  Widget _buildEmailField() => TextFormField(
        onChanged: (final String newVal) => userEmail = newVal,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'login.email'.tr,
          labelStyle: const TextStyle(fontSize: 20),
        ),
        validator: (final String? text) {
          if (text == null || text.isEmpty) {
            // return 'Email cannot be empty!';
            return 'login.empty-email'.tr;
          } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(text)) {
            // return 'Email must be proper format!';
            return 'login.email-format'.tr;
          }
          return null;
        },
      );

  Widget _buildPasswordField() => TextFormField(
        obscureText: true,
        onChanged: (final String newPass) => userPass = newPass,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'login.password'.tr,
          labelStyle: const TextStyle(fontSize: 20),
        ),
        validator: (final String? text) {
          if (text == null || text.isEmpty) {
            return 'login.empty-password'.tr;
          }
          return null;
        },
      );

  Widget _buildLoginForm(final GlobalKey<FormState> _formKey) => Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildEmailField(),
              _buildPasswordField(),
              // const SizedBox(height: 64.0),
              // _buildEmailSignInButton(),
              // const SizedBox(height: 16.0),
              // _buildGoogleButton(),
            ],
          ),
        ),
      );

  Widget _buildGoogleButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: FutureBuilder<FirebaseApp>(
            future: Authentication.initializeFirebase(context: context),
            builder: (
              final BuildContext context,
              final AsyncSnapshot<Object?> snapshot,
            ) {
              if (snapshot.hasError) {
                log('Error initializing firebase');
                log('DEBUG: ${snapshot.error}');
                log('DEBUG: ${snapshot.data}');
                return Text('login.error-initializing'.tr);
              } else if (snapshot.connectionState == ConnectionState.done) {
                return const GoogleSignInButton();
              }
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              );
            },
          ),
        ),
      );

  Widget _buildEmailSignInButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: OutlinedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final dynamic user = await Authentication.signInWithEmail(
                context: context,
                userEmail: emailController.text,
                userPassword: passwordController.text,
              );

              if (user.emailVerified) {
                DocumentSnapshot<Object?> doc =
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

                if (doc.get('firstRun') == true) {
                  unawaited(
                    Get.offAll(IntroScreen(user: user)),
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute<dynamic>(
                    //     builder: (final BuildContext context) =>
                    //         IntroScreen(user: user),
                    //   ),
                    // ),
                  );
                } else {
                  unawaited(
                    Get.offAll(const LibraryScreen()),
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute<dynamic>(
                    //     builder: (final BuildContext context) =>
                    //         const LibraryScreen(),
                    //   ),
                    // ),
                  );
                }
              } else {
                await user
                    ?.sendEmailVerification(); // TODO: Remove this later, move it to SignUp methods
                Get.snackbar(
                  '',
                  'login.verify-email'.tr,
                  snackPosition: SnackPosition.TOP,
                );
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('login.verify-email'.tr)),
                // );
                await FirebaseAuth.instance.signOut();
              }
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'login.sign-in'.tr,
                  style: const TextStyle(
                    color: Color(0xFF606060),
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildCreateAcctButton(final LoginScreenViewModel vm) => TextButton(
        child: Text(
          'login.create-account'.tr,
          style: vm.createAccountButtonStyle,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<dynamic>(
              builder: (final BuildContext context) => const SignUpScreen(),
            ),
          );
        },
      );

  Widget _buildForgotPassButton(final LoginScreenViewModel vm) => TextButton(
        child: Text('login.forgot-password'.tr, style: vm.passwordButtonStyle),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (final BuildContext context) =>
                  const ForgotPasswordScreen(),
            ),
          );
        },
      );

  Widget _buildSignInHeader(final double sh, final LoginScreenViewModel vm) {
    return SizedBox(
      height: sh / 3,
      child: Hero(
        tag: 'headerHero',
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset('assets/images/bookshelf.jpg', fit: BoxFit.cover),
              Center(
                child: Text(
                  'app-title'.tr,
                  textAlign: TextAlign.center,
                  style: vm.titleStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, LoginScreenViewModel>(
      distinct: true,
      converter: LoginScreenViewModel.create,
      builder: (final BuildContext context, final dynamic vm) {
        final double sh = MediaQuery.of(context).size.height;

        return GestureDetector(
          onTap: () {},
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: SizedBox(
                height: sh,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _buildSignInHeader(sh, vm),
                    _buildLoginForm(_formKey),
                    _buildEmailSignInButton(),
                    const SizedBox(height: 16.0),
                    _buildGoogleButton(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildCreateAcctButton(vm),
                        _buildForgotPassButton(vm),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
