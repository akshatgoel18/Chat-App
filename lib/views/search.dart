

//import 'dart:html';

import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/ConversationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  QuerySnapshot searchsnapshot;
  DatabaseMethods databaseMethods=new DatabaseMethods();
  final SearchEditingController=new TextEditingController();
  @override

  Widget SearchList()
  {
    return searchsnapshot !=null ? ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: searchsnapshot.documents.length,
      itemBuilder: (context,index)
      {
        return searchsnapshot.documents[index].data["name"]!=Constants.myName ? SearchTile(searchsnapshot.documents[index].data["name"], searchsnapshot.documents[index].data["Email"]):Container();
      },
    ) : Container();
  }
  createChatRoomandStartConversation(String Username)
  {
    print("On clicking on message");
    print(Username);
    print(Constants.myName);
    String chatroomid=getChatRoomId(Username, Constants.myName);
    List<String> users=[Username,Constants.myName];
    Map<String,dynamic> usermap={"chatroomid": chatroomid,"users":users};
    DatabaseMethods().createChatRoom(chatroomid, usermap);
    Navigator.push(context, MaterialPageRoute(
      builder: (context)=>ConversationScreen(chatroomid: chatroomid,personusername: Username,),
    ));
  }

  Widget SearchTile(String username,String email)
  {
    return  Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(username,style: TextStyle(color: Colors.white),),
                SizedBox(height: 5,),
                Text(email,style: TextStyle(color: Colors.white),),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                            createChatRoomandStartConversation(username);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(color: Colors.blue,borderRadius:BorderRadius.circular(13)),

                child: Text('Message',style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        )
    );
  }

  //create a chat room.send user to the conversation screen,(can use pushreplacement)



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Search'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
             Container(
               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
               color: Colors.grey,
               child: Row(
                 children: <Widget>[
                   Expanded(
                     child: TextField(
                       controller: SearchEditingController,
                       style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(border:InputBorder.none,hintText: 'search_username',hintStyle:TextStyle(color: Colors.grey[100])),
                     ),
                   ),
                   GestureDetector(
                       onTap: (){
                         databaseMethods.getUserByUsername(SearchEditingController.text).then((val){
                           setState(() {
                             searchsnapshot=val;
                           });
                         });

                       },
                       child: Icon(Icons.search))
                 ],
               ),
             ),
            SearchList(),

          ],
        ),
      )
      ,

    );
  }
}




getChatRoomId(String a,String b)
{
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0))
    {
      return "$b\_$a";
    }
  else
    return "$a\_$b";

}

