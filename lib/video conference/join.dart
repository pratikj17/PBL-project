import 'package:flutter/material.dart';
import 'package:pbl/video%20conference/createNewMeeting.dart';
import 'package:pbl/video%20conference/joinWithCode.dart';
// import 'package:get/get.dart';


class joinPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Column(
              children: [
                Center(
                  child : SizedBox(
                      width: 500,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>joinWithCode()));
                        },
                        child: const Text(
                          "Join Meeting",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                      ),
                  )
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Divider(
                  color: Colors.grey,
                  indent: 275,
                  endIndent: 275,
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Center(
                    child : SizedBox(
                      width: 500,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>createNewMeeting()));
                        },
                        child: const Text(
                          "Create New Meeting",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                        ),
                      ),
                    )
                ),
              ],
            ),
        )
      ],
    );
  }
}