import 'package:flutter/material.dart';
import 'package:pbl/screens/GroupChatScreen.dart';

import '../APIS/apis.dart';

class GroupTile extends StatefulWidget {
  final String groupname;
  final String groupid;
  const GroupTile({super.key, required this.groupname, required this.groupid});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_)=>GroupChatScreen(groupid: widget.groupid, groupname: widget.groupname, username: API.me.username,)));
      },
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: ListTile(
            leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Text(
                            widget.groupname.substring(0, 1).toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                    ),
            title: Text(
            widget.groupname,
            style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
      ),
    );
  }
}
