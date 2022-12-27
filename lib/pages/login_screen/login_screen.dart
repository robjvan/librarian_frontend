import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/login_screen/login_screen_view_model.dart';
import 'package:librarian_frontend/pages/login_screen/widgets/login_header/login_header.dart';
import 'package:librarian_frontend/pages/login_screen/widgets/widgets.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';

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
  bool _passwordObscured = true;
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
        obscureText: _passwordObscured,
        onChanged: (final String newPass) => userPass = newPass,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'login.password'.tr,
          labelStyle: const TextStyle(fontSize: 20),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordObscured
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _passwordObscured = !_passwordObscured;
              });
            },
          ),
        ),
        validator: (final String? text) {
          if (text == null || text.isEmpty) {
            return 'login.empty-password'.tr;
          }
          return null;
        },
      );

  Widget _buildGoogleButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: FutureBuilder<FirebaseApp>(
            future: AuthService.initializeFirebase(context: context),
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

  Widget _buildEmailSignInButton(final LoginScreenViewModel vm) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: OutlinedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              //   vm.signInWithEmail(
              //     context,
              //     emailController.text,
              //     passwordController.text,
              //   );
            }
          },
          style: vm.emailSigninButtonStyle,
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
        onPressed: () => Get.to(() => const SignUpScreen()),
      );

  Widget _buildForgotPassButton(final LoginScreenViewModel vm) => TextButton(
        child: Text('login.forgot-password'.tr, style: vm.passwordButtonStyle),
        onPressed: () => Get.to(() => const ForgotPasswordScreen()),
      );

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, LoginScreenViewModel>(
      distinct: true,
      converter: LoginScreenViewModel.create,
      builder: (final BuildContext context, final LoginScreenViewModel vm) {
        final double sh = MediaQuery.of(context).size.height;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SizedBox(
              height: sh,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const LoginHeader(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildEmailField(),
                        _buildPasswordField(),
                      ],
                    ),
                  ),
                  _buildEmailSignInButton(vm),
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
        );
      },
    );
  }
}
