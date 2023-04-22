import 'package:anime_app/partials/auth_form.dart';
import 'package:anime_app/partials/lock_icon.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const pageRoute = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              LockIcon(),
              const SizedBox(
                height: 40,
              ),
              AuthForm(formKey: _formKey, isSignIn: false),
            ]),
          ),
        ),
      ),
    );
  }
}
