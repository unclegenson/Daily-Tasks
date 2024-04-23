import 'package:flutter/material.dart';

class MyAppBarTitle extends StatelessWidget {
  final String title;
  final double fontSize;

  const MyAppBarTitle({
    super.key,
    required this.title,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'title',
          fontSize: fontSize,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
