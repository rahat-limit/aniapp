import 'package:flutter/material.dart';

class AuthLine extends StatelessWidget {
  const AuthLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Flexible(
              child: Container(
            height: 1,
            color: Colors.black,
          )),
          SizedBox(
            width: 70,
            child: Center(
                child: Text(
              'Or',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
            )),
          ),
          Flexible(
              child: Container(
            height: 1,
            color: Colors.black,
          ))
        ],
      ),
    );
  }
}
