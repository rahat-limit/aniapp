import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadDivider extends StatelessWidget {
  double width;
  double height;
  LoadDivider({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: const Color(0xFFDDC7C7),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
