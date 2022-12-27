import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/login_screen/forgot_password_screen/forgot_password_screen_view_model.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/authentication.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({final Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userEmail = '';
  bool _submitDisabled = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Widget _buildSubheader(final ForgotPasswordScreenViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text('Forgot password', style: vm.subheaderStyle),
    );
  }

  Widget _buildHeader(final double sh, final ForgotPasswordScreenViewModel vm) {
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

  Widget _buildEmailField() {
    return TextFormField(
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
  }

  void submitFn() {
    if (_formKey.currentState!.validate()) {
      AuthService.sendPasswordResetEmail(
        emailController.text,
        context,
      );
    }
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitDisabled ? null : submitFn,
      child: Text('submit'.tr),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[_buildEmailField(), _buildSubmitButton()],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return StoreConnector<GlobalAppState, ForgotPasswordScreenViewModel>(
      distinct: true,
      converter: ForgotPasswordScreenViewModel.create,
      builder: (
        final BuildContext context,
        final ForgotPasswordScreenViewModel vm,
      ) {
        final double sh = MediaQuery.of(context).size.height;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _buildHeader(sh, vm),
                _buildSubheader(vm),
                _buildForm(),
              ],
            ),
          ),
        );
      },
    );
  }
}
