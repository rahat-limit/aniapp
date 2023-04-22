import 'package:flutter/material.dart';

class LockIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Image.asset('assets/images/lock.png')],
    );
  }
}
