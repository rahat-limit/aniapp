import 'package:anime_app/partials/auth_button.dart';
import 'package:anime_app/partials/auth_field.dart';
import 'package:anime_app/partials/lock_icon.dart';
import 'package:anime_app/partials/reset_lock_icon.dart';
import 'package:anime_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key});
  static const pageRoute = '/reset';

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    var _emailResetController = TextEditingController();
    void showErrorMessage(String error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          error,
        ),
        duration: const Duration(milliseconds: 800),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Theme.of(context).errorColor,
      ));
    }

    void _submit() async {
      if (_emailResetController.text.isEmpty)
        return showErrorMessage('Fill an empty field.');
      if (!RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(_emailResetController.text.trim()))
        return showErrorMessage('Invalid Email address!');
      String statusMessage =
          await AuthService().resetPassword(_emailResetController.text.trim());

      if (statusMessage.trim() != '') {
        return showErrorMessage(statusMessage);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Success! Check your mail:)',
        ),
        duration: const Duration(milliseconds: 800),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        backgroundColor: Colors.green[500],
      ));
    }

    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResetLockIcon(),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _key,
              child: Column(children: [
                AuthField(
                    label: 'Email',
                    controller: _emailResetController,
                    isPassword: false),
                const SizedBox(
                  height: 20,
                ),
                AuthButton(text: 'Reset', submitFunc: () => _submit())
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Row(children: [
                  const Icon(
                    Icons.arrow_back_sharp,
                    color: Color(0xFF539DB4),
                    size: 17,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'Go Back',
                    style: TextStyle(
                        color: Color(0xFF539DB4),
                        fontSize: 17,
                        fontWeight: FontWeight.w300),
                  )
                ]),
              ),
            )
          ],
        )),
      )),
    );
  }
}
