import 'package:flutter/material.dart';

class LoadDivider extends StatelessWidget {
  double width;
  double height;
  LoadDivider({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Color(0xFFDDC7C7), borderRadius: BorderRadius.circular(10)),
    );
  }
}
