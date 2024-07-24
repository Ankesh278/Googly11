

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool  obscureText;
  final IconData ? prefixIcon;

  const CustomTextField({required this.labelText, this.obscureText = false,  this.prefixIcon});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        height: 45,
        child: TextFormField(
          validator: (value){
            if(value == null || value.isEmpty){
              return Fluttertoast.showToast(msg: "Enter Email").toString();
            }
          },
          obscureText: widget.obscureText ? _obscureText : false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.black,width: 5.0,strokeAlign: 3),
              borderRadius: BorderRadius.circular(12)
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: widget.labelText,
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: _obscureText
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
            prefixIcon:Icon(widget.prefixIcon)
          ),
        ),
      ),
    );
  }
}



