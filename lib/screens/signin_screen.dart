import 'package:anime_app/partials/auth_form.dart';
import 'package:anime_app/partials/lock_icon.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const pageRoute = '/signin';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              LockIcon(),
              SizedBox(
                height: 40,
              ),
              AuthForm(formKey: _formKey, isSignIn: true),
            ]),
          ),
        ),
      ),
    );
  }
}
