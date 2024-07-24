import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:world11/resourses/Image_Assets/image_assets.dart';

class RowNColumn extends StatelessWidget {
  final IconData  icon;
  final String text ;

   RowNColumn({Key? key, required this.icon, required this.text,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(

      children: [
        Column(
          children: [
            SizedBox(height: size.height *0.02,),
            Icon(icon),
            Text(text,)
          ],
        ),

      ],
    );
  }
}
