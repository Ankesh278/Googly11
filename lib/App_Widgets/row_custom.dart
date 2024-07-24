
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
   Icon? iconData;
  final String? text;
  final Image? image;
  final TextStyle style;

  CustomRow({ this.iconData, this.text,this.style = const TextStyle(), this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              SizedBox(width: 20,),
              if (image != null) image!,
              SizedBox(width: 32,),
              if (iconData != null) iconData!,

              if (iconData != null && text != null) SizedBox(width: 8),

              if (text != null) Text(text!,style: style,),
              if (text != null && image != null) SizedBox(width: 8),

            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: 0.3,
        ),
      ],
    );
  }
}