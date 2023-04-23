import 'package:anime_app/partials/auth_button.dart';
import 'package:anime_app/partials/auth_field.dart';
import 'package:anime_app/partials/reset_lock_icon.dart';
import 'package:anime_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class ResetScreen extends StatelessWidget {
  const ResetScreen({super.key});
  static const pageRoute = '/reset';

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    var emailResetController = TextEditingController();
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

    // ignore: no_leading_underscores_for_local_identifiers
    void _submit() async {
      if (emailResetController.text.isEmpty) {
        return showErrorMessage('Fill an empty field.');
      }
      if (!RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(emailResetController.text.trim())) {
        return showErrorMessage('Invalid Email address!');
      }
      String statusMessage =
          await AuthService().resetPassword(emailResetController.text.trim());

      if (statusMessage.trim() != '') {
        return showErrorMessage(statusMessage);
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
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
            const ResetLockIcon(),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: key,
              child: Column(children: [
                AuthField(
                    label: 'Email',
                    controller: emailResetController,
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
                child: Row(children: const [
                  Icon(
                    Icons.arrow_back_sharp,
                    color: Color(0xFF539DB4),
                    size: 17,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
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
