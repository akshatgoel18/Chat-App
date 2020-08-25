//import 'dart:collection';

import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/ChatRoomScreen.dart';
import 'package:chat_app/views/register.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget   {
   final  Function changestate;
    SignIn({this.changestate});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods=new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  QuerySnapshot snapshot;
  bool isloading=false;
  SignInMe()
  {
    if(formkey.currentState.validate())
      {
        setState(() {
          isloading=true;
        });
        print("working ok");
        return authMethods.signInWithEmailandPassword(EmailidTextEditingController.text, PasswordTextEditingController.text).then((value) async {
          HelperFunctions.SaveUserLoggedInSharedPreference(true);
          print(EmailidTextEditingController.text);
          await databaseMethods.getUserByUserEmail(EmailidTextEditingController.text).then((val) async{
            snapshot=val;
            //print(snapshot.documents);
            print("username is ");
             HelperFunctions.SaveUserNameSharedPreference(snapshot.documents[0].data["name"]);
          });
          Navigator.pushReplacement(context, MaterialPageRoute(
             builder: (context)=> ChatRoom(Email: EmailidTextEditingController.text),
          ));
        });
      }

  }
  final formkey =GlobalKey<FormState>();
  TextEditingController EmailidTextEditingController=TextEditingController();
  TextEditingController PasswordTextEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        backgroundColor: Colors.blue,
      ),
      body:  isloading ? Center(child: CircularProgressIndicator()) :SingleChildScrollView(
        child: Container(
            height:MediaQuery.of(context).size.height-90,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomCenter,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(

                        validator: (val)=> val.length==0 ? "This field is empty" : null,
                        controller: EmailidTextEditingController,
                        style:TextStyle(color: Colors.white,fontSize: 20),
                        decoration:signinfields('E-mail'),

                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val)=> val.length<=6 ? "This field is empty" : null
                        ,controller: PasswordTextEditingController,
                        style:TextStyle(color: Colors.white,fontSize: 20),
                        decoration:signinfields('Password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('Forgot Password?',style: TextStyle(color: Colors.white,fontSize: 15),),
                ),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(borderRadius:BorderRadius.circular(30),color: Colors.blue),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 130,vertical: 20),
                    child: GestureDetector(
                       onTap:(){SignInMe();},
                        child: Text('Sign In',style: TextStyle(color: Colors.white),)),
                  ),
                ),
                SizedBox(height:20,),
                Container(

                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),color: Colors.red),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 100),
                    child: Text('Sign In with Google',style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Not Having Account?",style: TextStyle(color: Colors.white),),
                    SizedBox(width: 5,),
                    GestureDetector(
                       onTap: (){
                         widget.changestate();
                       },
                        child: Text("Register now",style: TextStyle(color: Colors.white,decoration: TextDecoration.underline),))
                  ],
                ),
                SizedBox(height: 40,)


              ],
            )

        ),
      ),
    );
  }
}
