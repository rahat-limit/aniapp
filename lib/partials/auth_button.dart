import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback submitFunc;
  // ignore: prefer_const_constructors_in_immutables
  AuthButton({super.key, required this.text, required this.submitFunc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: submitFunc,
                style: ElevatedButton.styleFrom(
                    // ignore: use_full_hex_values_for_flutter_colors
                    backgroundColor: const Color(0xffF2E2E2E),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
