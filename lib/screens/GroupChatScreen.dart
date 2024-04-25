import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbl/APIS/apis.dart';

import '../widgets/GroupMessageTile.dart';
import 'group_info.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupid;
  final String groupname;
  final String username;
  const GroupChatScreen({super.key, required this.groupid, required this.groupname, required this.username});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  Stream <QuerySnapshot>? chats;
  String admin="Unknown";
  TextEditingController messageController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState()  {
    // TODO: implement initState
    chats=API().getChats(widget.groupid);
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });

    // API().getChats(widget.groupid).then((val){
    //   setState(() {
    //     chats=val;
    //   });
    // });
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() async{
    // await
    await API().getGroupAdmin(widget.groupid).then((val){
      setState(() {
        admin=val.substring(val.indexOf("_") + 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(widget.groupname),
        centerTitle: true,
        backgroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupInfo(groupid: widget.groupid, groupname: widget.groupname, adminname: admin,)));
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
            child: CircularProgressIndicator(),
          )
          :Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              color: Colors.white60,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: OutlineInputBorder( // Use OutlineInputBorder for border
                        borderSide: BorderSide(
                          color: Colors.white, // Adjust the color as needed
                          width: 2.0, // Adjust the width as needed
                        ),
                        borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return MessageTile(
                message: snapshot.data.docs[index]['message'],
                sender: snapshot.data.docs[index]['sender'],
                sentByMe: widget.username ==
                    snapshot.data.docs[index]['sender']);
          },
        )
            : Container(child: Text("No chats"),);
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      API().sendGroupMessage(widget.groupid, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
