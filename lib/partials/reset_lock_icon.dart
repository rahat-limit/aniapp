import 'package:flutter/material.dart';

class ResetLockIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/forgot-password.png',
          width: 100,
        )
      ],
    );
  }
}
