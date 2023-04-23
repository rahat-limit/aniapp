import 'package:anime_app/partials/auth_button.dart';
import 'package:anime_app/partials/auth_field.dart';
import 'package:anime_app/partials/auth_line.dart';
import 'package:anime_app/provider/anime_library.dart';
import 'package:anime_app/screens/divider_screen.dart';
import 'package:anime_app/screens/reset_screen.dart';
import 'package:anime_app/screens/signin_screen.dart';
import 'package:anime_app/screens/signup_screen.dart';
import 'package:anime_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  var formKey = GlobalKey<FormState>();
  bool isSignIn;
  AuthForm({super.key, required this.formKey, required this.isSignIn});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _emailController.text = '';
    _passwordConfirmController.text = '';
    _passwordConfirmController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showErrorMessage(String error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
        ),
        duration: const Duration(milliseconds: 800),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }

    void showClueMessage(String error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
        ),
        duration: const Duration(milliseconds: 800),
        showCloseIcon: true,
        closeIconColor: Colors.amber,
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }

    Future<void> submit() async {
      try {
        if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
          return showErrorMessage("Fill an empty fields.");
        }

        if (!widget.isSignIn && _passwordConfirmController.text.isEmpty) {
          return showErrorMessage('Fill an empty fields.');
        }

        if (!RegExp(
                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(_emailController.text.trim())) {
          return showErrorMessage('Invalid Email address!');
        }

        if (_passwordController.text.trim().length < 6) {
          return showClueMessage(
              'Password should be at least 6 charaters long.');
        }

        if (_passwordController.text.trim() !=
                _passwordConfirmController.text.trim() &&
            !widget.isSignIn) {
          return showErrorMessage('Passwords are not the same.');
        }
        !widget.isSignIn
            ? await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              )
            : await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
        // ignore: use_build_context_synchronously
        Provider.of<AnimeLibrary>(context, listen: false).signedIn();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed(DividerScreen.pageRoute);
      } on FirebaseAuthException catch (e) {
        if (!widget.isSignIn) {
          if (e.code == 'weak-password' &&
              _passwordController.text.isNotEmpty &&
              _passwordConfirmController.text.isNotEmpty) {
            showClueMessage('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use' &&
              _emailController.text.isNotEmpty) {
            showClueMessage('The account already exists for that email.');
          }
        } else {
          if (e.code == 'user-not-found') {
            showClueMessage('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            showClueMessage('Wrong password provided for that user.');
          }
        }
      }
    }

    return Form(
      key: widget.formKey,
      child: Column(children: [
        AuthField(
            label: 'Email', controller: _emailController, isPassword: false),
        const SizedBox(
          height: 10,
        ),
        AuthField(
          label: 'Password',
          controller: _passwordController,
          isPassword: true,
        ),
        !widget.isSignIn
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox(),
        !widget.isSignIn
            ? AuthField(
                label: 'Confirm Password',
                controller: _passwordConfirmController,
                isPassword: true,
              )
            : const SizedBox(),
        const SizedBox(
          height: 13,
        ),
        widget.isSignIn
            ? Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushNamed(ResetScreen.pageRoute),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        const SizedBox(
          height: 20,
        ),
        AuthButton(
            text: widget.isSignIn ? 'Sign In' : 'Sign Up', submitFunc: submit),
        const SizedBox(
          height: 50,
        ),
        const AuthLine(),
        const SizedBox(height: 30),
        GestureDetector(
            child: Image.asset('assets/images/google.png'),
            onTap: () async {
              await AuthService().signInWithGoogle(context);
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, DividerScreen.pageRoute);
            }),
        const SizedBox(
          height: 20,
        ),
        widget.isSignIn
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member, ',
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(SignUpScreen.pageRoute),
                    child: const Text(
                      'Register here',
                      style: TextStyle(color: Color(0xFF539DB4), fontSize: 18),
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already registered? ',
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed(SignInScreen.pageRoute),
                    child: const Text(
                      'Login here',
                      style: TextStyle(color: Color(0xFF539DB4), fontSize: 18),
                    ),
                  )
                ],
              )
      ]),
    );
  }
}
