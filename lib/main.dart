import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/views/ChatRoomScreen.dart';
import 'package:chat_app/views/register.dart';
import 'package:chat_app/views/signin.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isonline=false;
  bool isloading=true;

  getinfo()async
  {
    isonline=await HelperFunctions.GetUserLoggedInSharedPreference();
    if(isonline==null)
      isonline=false;
    setState(() {
      isloading=false;
    });
    print("printed1");
  }
   @override
  void initState() {
     getinfo();
     // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isloading ?Center(child: CircularProgressIndicator()) :MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home:isonline ? ChatRoom() : Authenticate(),
    );
  }
}
