import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MiniContainer extends StatelessWidget {
  final bool filled;

  MiniContainer({required this.filled});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return Container(
      height: size.height * 0.03,
      width: size.width * 0.07,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            bottomRight: Radius.circular(5)
        ),
        color: filled ? Colors.green : Colors.transparent,
      ),
    );
  }
}
