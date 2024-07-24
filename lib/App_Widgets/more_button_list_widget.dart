
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardIconText extends StatelessWidget {
  final IconData? iconData;
  final String? text;
  final Image? image;
  final TextStyle style;

  CardIconText({this.iconData, this.text,this.style = const TextStyle(), this.image});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        decoration: BoxDecoration(
        ),
        height:size.height *.1,
        width: size.width *.9,
        child: Card(
          child: Row(
            children: [
              SizedBox(width: 20,),
              if (image != null) image!,
              SizedBox(width: 32,),
              if (iconData != null) Icon(iconData),
              if (iconData != null && text != null) SizedBox(width: 8),
              if (text != null) Text(text!,style: style,),
              if (text != null && image != null) SizedBox(width: 8),

            ],
          ),
        ),
      ),
    );
  }
}