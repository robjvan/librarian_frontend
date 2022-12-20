import 'package:flutter/material.dart';

    // TODO: Add 'Forgot password' functionality

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({final Key? key}) : super(key: key);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Text('Forgot password'),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
