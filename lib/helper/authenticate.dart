import 'package:chat_app/views/register.dart';
import 'package:chat_app/views/signin.dart';
import 'package:flutter/material.dart';
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool toshow=false;
  void changestate(){
    setState(() {
      toshow=!toshow;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  toshow? SignUp(changestate: changestate,) :  SignIn(changestate: changestate,);
  }
}
