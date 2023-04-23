import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  bool isPassword = false;
  AuthField(
      {super.key,
      required this.label,
      required this.controller,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
          hintStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: label,
        ),
      ),
    );
  }
}
