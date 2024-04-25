import 'package:flutter/material.dart';
import 'package:pbl/video%20conference/video_call.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class createNewMeeting extends StatefulWidget{
  @override
  State<createNewMeeting> createState() => _createNewMeetingState();
}

class _createNewMeetingState extends State<createNewMeeting> {

  String _meetingCode="abcdfgqw";

  @override
  void initState(){
    var uuid=Uuid();
    String temp=uuid.v1();
    _meetingCode=temp.substring(0,8);
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10,left: 30)),
          Align(
            child: InkWell(
              child : Icon(Icons.arrow_back_ios_outlined),
              onTap:()=> Navigator.pop(context),
            ),
            alignment: Alignment.topLeft,
          ),
          Center(
            child: Text(
              "Your channel is ready",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 350,
            child: Padding(
              padding: EdgeInsets.only(top : 20),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.link),
                  title: SelectableText(
                    _meetingCode,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          Divider(
            color: Colors.grey,
            indent: 275,
            endIndent: 275,
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          SizedBox(
            width: 500,
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>VideoCall(channelName: _meetingCode.trim())));
              },
              child: const Text(
                "Create New Meeting",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          SizedBox(
            width: 500,
            height: 30,
            child: ElevatedButton.icon(
              onPressed: (){
                Share.share("Meeting Invite : $_meetingCode");
              },
              icon: Icon(Icons.arrow_drop_down_outlined,color: Colors.white),
              label: Text("Share Invite",style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}