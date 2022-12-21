import 'package:flutter/material.dart';

// TODO(Rob): Build sign up screen and functionality

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({final Key? key}) : super(key: key);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Text('Sign Up'),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
