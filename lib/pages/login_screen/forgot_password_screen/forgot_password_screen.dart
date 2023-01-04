import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:librarian_frontend/pages/login_screen/forgot_password_screen/forgot_password_screen_view_model.dart';
import 'package:librarian_frontend/pages/login_screen/widgets/login_header/login_header.dart';
import 'package:librarian_frontend/state.dart';
import 'package:librarian_frontend/utilities/theme.dart';

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

  @override
  void initState() {
    super.initState();
    emailController.text = 'rob@test.com';
  }

  Widget _buildSubheader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child:
          Text('forgot-password'.tr, style: AppTextStyles.loginSubheaderStyle),
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
      ),
    );
  }

  Widget _buildSubmitButton(final ForgotPasswordScreenViewModel vm) {
    return ElevatedButton(
      onPressed: _submitDisabled
          ? null
          : () => vm.submitFn(_formKey, emailController.text, context),
      child: Text('send'.tr),
    );
  }

  Widget _buildBlurb(final ForgotPasswordScreenViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Text(
        'send-reset-link'.tr,
        style: vm.blurbStyle,
        textAlign: TextAlign.center,
      ),
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
    return StoreConnector<GlobalAppState, ForgotPasswordScreenViewModel>(
      distinct: true,
      converter: ForgotPasswordScreenViewModel.create,
      builder: (
        final BuildContext context,
        final ForgotPasswordScreenViewModel vm,
      ) {
        return Scaffold(
          // resizeToAvoidBottomInset: false,
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
                        _buildBlurb(vm),
                        const SizedBox(height: 32),
                        _buildEmailField(),
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
