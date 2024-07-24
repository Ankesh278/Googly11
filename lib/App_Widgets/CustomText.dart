import 'package:flutter/material.dart';

class CustomPaddedText extends StatelessWidget {
  final String text;
  final TextStyle style;

  final EdgeInsetsGeometry padding;

  CustomPaddedText({
    required this.text,
    this.style = const TextStyle(),
    this.padding = const EdgeInsets.only(left: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}
