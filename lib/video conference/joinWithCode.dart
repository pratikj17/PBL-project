import 'package:flutter/material.dart';
import 'package:pbl/video%20conference/video_call.dart';
// import 'package:get/get.dart';

class joinWithCode extends StatelessWidget{

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10,left: 30)),
            Align(
              child: InkWell(
                child : Icon(Icons.arrow_back_ios_outlined),
                onTap:()=>Navigator.pop(context),
              ),
              alignment: Alignment.topLeft,
            ),
            Padding(padding: EdgeInsets.only(top: 10,left: 30)),
            SizedBox(
                width: 600,
                child: Column(
                  children: [
                    TextFormField(
                      controller : _controller,
                      decoration: InputDecoration(
                          labelText: "Channel ID",
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                          ),
                          hintText: "Enter your channel-id....",
                          hintStyle: const TextStyle(
                            color: Color(0xFF57636C),
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // Set border for focused state
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                          )

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Container(
                      width: 600,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(width: 1, color: Colors.black),
                          ),

                        ),

                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>VideoCall(channelName: _controller.text)));
                        },
                        child: Text(
                          "Join Room",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}