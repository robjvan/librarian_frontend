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
  bool _obscurePassword = true;
  bool _showPasswordRequirements = false;

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
        'register-blurb'.tr,
        style: AppTextStyles.blurbStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
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
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 16),
      child: SizedBox(
        child: TextFormField(
          obscureText: _obscurePassword,
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
            suffixIcon: IconButton(
              icon: _obscurePassword
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            labelText: 'password'.tr, // TODO(Rob): Add i18n
            labelStyle: const TextStyle(fontSize: 20),
          ),
          validator: (final String? text) {
            final RegExp regex = RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
            );

            if (text == null || text.isEmpty) {
              return 'password.empty-password'.tr;
            } else {
              if (!regex.hasMatch(text)) {
                _showPasswordRequirements = true;
                return 'password.invalid'.tr;
                // return '';
              } else if (regex.hasMatch(text)) {
                _showPasswordRequirements = false;
                return null;
              }
            }
          },
        ),
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

  Widget _buildPasswordRequirements() {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 48.0, right: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('password.rules'.tr, textAlign: TextAlign.start),
            Text('password.lower-case'.tr),
            Text('password.upper-case'.tr),
            Text('password.symbol'.tr),
            Text('password.number'.tr),
          ],
        ),
      ),
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
                        const SizedBox(height: 16),
                        _buildEmailField(),
                        _buildPasswordField(),
                        _showPasswordRequirements
                            ? _buildPasswordRequirements()
                            : Container(),
                        const SizedBox(height: 16),
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
