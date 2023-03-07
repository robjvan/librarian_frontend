import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/login_screen/login_screen_view_model.dart';
import 'package:librarian_frontend/pages/pages.dart';
import 'package:librarian_frontend/services/authentication.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:librarian_frontend/widgets/widgets.dart';
import 'package:redux/redux.dart';

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
    emailController.text = 'rob@robjvan.ca';
    passwordController.text = 'Asdf123!';
    super.initState();
  }

  Widget _buildEmailField() {
    return TextFormField(
      onChanged: (final String newVal) => userEmail = newVal,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      decoration: InputDecoration(
        labelText: 'email'.tr,
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
  }

  Widget _buildPasswordField() {
    return TextFormField(
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
  }

  Widget _buildGoogleButton() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: GoogleSignInButton(),
    );
  }

  Widget _buildEmailSignInButton(final LoginScreenViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: OutlinedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            vm.signInWithEmail(
              context,
              emailController.text,
              passwordController.text,
            );
          }
        },
        style: vm.emailSigninButtonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text(
                'sign-in'.tr,
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
  }

  Widget _buildCreateAcctButton(final LoginScreenViewModel vm) {
    return TextButton(
      child: Text(
        'login.create-account'.tr,
        style: AppTextStyles.createAccountButtonStyle,
      ),
      onPressed: () => Get.to(() => const SignUpScreen()),
    );
  }

  Widget _buildForgotPassButton(final LoginScreenViewModel vm) {
    return TextButton(
      child: Text('login.forgot-password'.tr,
        style: AppTextStyles.passwordButtonStyle,
      ),
      onPressed: () => Get.to(() => const ForgotPasswordScreen()),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _buildEmailField(),
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, LoginScreenViewModel>(
      onInit: (final Store<GlobalAppState> store) =>
          AuthService.initializeFirebase(context: context),
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
                  _buildForm(),
                  const SizedBox(height: 16.0),
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
