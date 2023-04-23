import 'package:anime_app/partials/auth_form.dart';
import 'package:anime_app/partials/lock_icon.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const pageRoute = '/signin';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const LockIcon(),
              const SizedBox(
                height: 40,
              ),
              AuthForm(formKey: formKey, isSignIn: true),
            ]),
          ),
        ),
      ),
    );
  }
}
