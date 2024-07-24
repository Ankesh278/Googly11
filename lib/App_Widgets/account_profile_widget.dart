import 'package:flutter/material.dart';

class AccountProfileWidget extends StatefulWidget {
  final String  text;
  final TextStyle textStyle;
  
  const AccountProfileWidget({Key? key, required this.text, required this.textStyle}) : super(key: key);
  

  @override
  State<AccountProfileWidget> createState() => _AccountProfileWidgetState();
}

class _AccountProfileWidgetState extends State<AccountProfileWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  Container(
      height: size.height *0.05,
      width: size.width *0.9,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Center(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left:12),
            child: Text(
            widget.text,
              style:widget.textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
