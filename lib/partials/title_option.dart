import 'package:flutter/material.dart';

class TitleOption extends StatelessWidget {
  final String url;
  final String text;
  const TitleOption({super.key, required this.url, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            url,
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
              child: Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          ))
        ],
      ),
    );
  }
}
