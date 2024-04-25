import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl/APIS/apis.dart';
import 'package:pbl/main.dart';
import 'package:pbl/models/ChatUser.dart';
import 'package:pbl/screens/Profile.dart';
class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  ViewProfileScreen( {Key? key, required this.user}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus() ,
      child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text(widget.user.username)),
          ),
          body:Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width*0.05 ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height*0.03,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height),
                    child: CachedNetworkImage(
                      width: mq.height*0.2,
                      height: mq.height*0.2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(child: Icon( Icons.person),),
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height*0.03,
                  ),
                  Text(widget.user.email,style: TextStyle(color: Colors.black87,fontSize: 16),),
                  SizedBox(
                    width: mq.width,
                    height: mq.height*0.05,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('About: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: 20),),
                      Text(widget.user.instruments,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                    ],
                  ),
                  SizedBox(height: mq.height*0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Social Media : ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: 20),),
                      Text(widget.user.instaid,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                    ],
                  ),
                  SizedBox(height: mq.height*0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Primary Location: ',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.w300,fontSize: 20),),
                      Text(widget.user.location ,style: const TextStyle(color:Colors.black87,fontSize: 18),),
                    ],
                  ),
                  SizedBox(height: mq.height*0.05),
                  ElevatedButton(
                      onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(Uid: widget.user.id,)));
                  }, child: Text('View Complete Profile')),
                ],
              ),
            ),
          )
      ),
    );
  }


}

