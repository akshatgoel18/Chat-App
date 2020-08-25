import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/ConversationScreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:flutter/cupertino.dart';

class ChatRoom extends StatefulWidget {
  @override
  String Email;

  ChatRoom({this.Email});
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods=new DatabaseMethods();
  @override

  Stream chatroomstream;
  Widget ChatRoomList()
  {
    return StreamBuilder(
      stream: chatroomstream,
      builder: (context,snapshot)
      {
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
             // print("one");
             // print(Constants.myName);
              return ChatRoomtile(username: snapshot.data.documents[index].data["chatroomid"].
              toString().replaceAll("_", "").replaceAll(Constants.myName, ""),chatroomid: snapshot.data.documents[index].data["chatroomid"],);
            }): Container();
      },
    );
  }

  void initState()
  {
    getuserinfo();



  }

  getuserinfo() async
  {
    Constants.myName=await HelperFunctions.GetUserNameSharedPreference();
    await databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatroomstream=val;
      });
    });
   // print(Constants.myName);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('ChatRoom',style: TextStyle(color: Colors.white),),
        actions: <Widget>[
           GestureDetector(
               onTap: ()async {
                 await HelperFunctions.SaveUserLoggedInSharedPreference(false);
                 authMethods.SignOut();
                 Navigator.pushReplacement( context,MaterialPageRoute(builder: (BuildContext context) => Authenticate()));
               },
               child: Container(padding:EdgeInsets.symmetric(horizontal: 10),child: Icon(Icons.exit_to_app)))
        ],
      ),
      floatingActionButton:FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(
            builder: (context)=>Search()

          ));
        },
      ),
      body: ChatRoomList(),
    );
  }
}
class ChatRoomtile extends StatelessWidget {
  @override
  String username="username";
  String chatroomid;
  ChatRoomtile({this.username,this.chatroomid});
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>ConversationScreen(chatroomid: chatroomid,personusername: username,)
          ));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          color: Colors.blue[400],
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color:Colors.blue[800],borderRadius: BorderRadius.circular(48)),
                child: Text(username.length >0 ? username.substring(0,1).toUpperCase() : "ChatHere",style:TextStyle(fontSize: 20),),
              ),
              SizedBox(width: 20,),
              Text(username,style: TextStyle(color: Colors.white),),




            ],
          ),
        ),
      ),
    );
  }
}
