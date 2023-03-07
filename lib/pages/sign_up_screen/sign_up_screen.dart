import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/sign_up_screen/sign_up_screen_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';
import 'package:librarian_frontend/widgets/widgets.dart';

// TODO(Rob): Build sign up screen and functionality

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({final Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userEmail = '';
  String userPassword = '';
  bool _submitDisabled = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildSubheader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text('register'.tr, style: AppTextStyles.loginSubheaderStyle),
    );
  }

  Widget _buildBlurb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Text(
        'send-reset-link'.tr,
        style: AppTextStyles.blurbStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: TextFormField(
        onChanged: (final String newVal) {
          userEmail = newVal;
          if (_formKey.currentState!.validate()) {
            setState(() {
              _submitDisabled = false;
            });
          } else {
            setState(() {
              _submitDisabled = true;
            });
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'email'.tr,
          labelStyle: const TextStyle(fontSize: 20),
        ),
        validator: (final String? text) {
          if (text == null || text.isEmpty) {
            // return 'Email cannot be empty!';
            return 'empty-email'.tr;
          } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(text)) {
            // return 'Email must be proper format!';
            return 'login.email-format'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: TextFormField(
        onChanged: (final String newVal) {
          userEmail = newVal;
          if (_formKey.currentState!.validate()) {
            setState(() {
              _submitDisabled = false;
            });
          } else {
            setState(() {
              _submitDisabled = true;
            });
          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: passwordController,
        decoration: InputDecoration(
          labelText: 'password'.tr, // TODO(Rob): Add i18n
          labelStyle: const TextStyle(fontSize: 20),
        ),
        validator: (final String? text) {
          if (text == null || text.isEmpty) {
            // return 'Password cannot be empty!';
            return 'empty-password'.tr;
          } else if (!RegExp(
            // TODO(Rob): Change to password RegEx
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
          ).hasMatch(text)) {
            // TODO(Rob): show widget listing password criteria if not met
            // return 'Password must contain one upper case, one lower case, one number!';
            // return 'login.email-format'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton(final SignUpScreenViewModel vm) {
    return ElevatedButton(
      onPressed: _submitDisabled
          ? null
          : () {
              // vm.submitFn(_formKey, emailController.text, context);
            },
      child: Text('send'.tr),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: Get.back,
      child: Text('cancel'.tr),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, SignUpScreenViewModel>(
      distinct: true,
      converter: SignUpScreenViewModel.create,
      builder: (
        final BuildContext context,
        final SignUpScreenViewModel vm,
      ) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const LoginHeader(),
                  _buildSubheader(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildBlurb(),
                        const SizedBox(height: 32),
                        _buildEmailField(),
                        _buildPasswordField(),
                        _buildSubmitButton(vm),
                        _buildCancelButton(),
                      ],
                    ),
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
