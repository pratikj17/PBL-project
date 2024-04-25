import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl/main.dart';
import 'package:pbl/models/ChatUser.dart';
import 'package:pbl/screens/ChatUserScreen.dart';
import 'package:pbl/widgets/profile%20dialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user: widget.user))),
      child: Container(
        padding: EdgeInsets.only(bottom: 4,left:5,right: 5),
      margin: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 5),
      decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey.shade200)),),
        child: ListTile(
          // leading: CircleAvatar(child: Icon(CupertinoIcons.person),),
          leading: InkWell(
            onTap: (){
              showDialog(context: context, builder: (_)=>ProfileDialog(user:widget.user));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height),
              child: CachedNetworkImage(
                width: mq.height*0.063,
                height: mq.height*0.065,
                fit: BoxFit.cover,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>  CircleAvatar(
                  child: Text(
                    widget.user.username.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: Colors.grey,
                  ),
              ),
            ),
          ),
          title: Text(widget.user.username,),
        ),
      ),
    );
  }
}
