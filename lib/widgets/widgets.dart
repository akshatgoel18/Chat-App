import 'package:flutter/material.dart';

AppBar appbarfunction(context)
{
  return AppBar(
    backgroundColor: Colors.blue,
    title : Text(
      "Chat App",
      style:TextStyle(
        fontSize: 20,
        color: Colors.white

      ) ,
    )
  );
}
InputDecoration signinfields(String hint)
{
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.white
        ,fontSize: 15,
      ),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color:Colors.white)
      ),
      focusColor: Colors.orange,

    );
}
