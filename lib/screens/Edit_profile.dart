
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl/APIS/apis.dart';
import 'package:pbl/main.dart';
import 'package:pbl/models/ChatUser.dart';
class EditProfile extends StatefulWidget {
  final ChatUser user;
  EditProfile( {Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey=GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus() ,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Profile')),
        ),
        body:Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width*0.05 ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height*0.03,
                  ),
                  Stack(
                    children: [
                      //profile picture
                      _image!=null ?
                      //local image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height),
                        child: Image.file(
                          File(_image!),
                          width: mq.height*0.2,
                          height: mq.height*0.2,
                          fit: BoxFit.cover,
                        ),)
                          :
                      //image from server
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
                      Positioned(
                        bottom: -10,
                        right: 0,
                        child: MaterialButton(
                          elevation: 5,
                          onPressed: (){
                            _showbottomsheet();
                          },
                          color:Colors.white,
                          shape: const CircleBorder(),
                          child:const Icon(Icons.edit,color: Colors.blue,),),
                      )
                    ],
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height*0.03,
                  ),
                  Text(widget.user.email,style: TextStyle(color: Colors.black54,fontSize: 16),),
                  SizedBox(
                    width: mq.width,
                    height: mq.height*0.05,
                  ),
                  TextFormField(
                    onSaved: (val)=>API.me.username=val ?? "",
                    validator: (val)=> val!=null && val.isNotEmpty  ?null :"Required field",
                    initialValue: widget.user.username,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)
                      )
                    ),
                  ),
                  SizedBox(height: mq.height*0.02,),
                  TextFormField(
                    onSaved: (val)=>API.me.instaid=val ?? "",
                    validator: (val)=> val!=null && val.isNotEmpty  ?null :"Required field",
                    initialValue: widget.user.instaid,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.facebook),
                        labelText: "Social media",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                  ),
                  SizedBox(height: mq.height*0.02,),
                  TextFormField(
                    onSaved: (val)=>API.me.location=val ?? "",
                    validator: (val)=> val!=null && val.isNotEmpty  ?null :"Required field",
                    initialValue: widget.user.location,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on),
                        labelText: "location",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                  ),
                  SizedBox(height: mq.height*0.02,),
                  TextFormField(
                    onSaved: (val)=>API.me.instruments=val ?? "",
                    validator: (val)=> val!=null && val.isNotEmpty  ?null :"Required field",
                    initialValue: widget.user.instruments,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.music_note),
                        labelText: "instruments",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                  ),
                  SizedBox(height: mq.height*0.05,),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      minimumSize: Size(mq.width*0.4, mq.height*0.07)
                    ),
                      onPressed: (){
                        if(_formkey.currentState!.validate()){
                          _formkey.currentState!.save();
                          API.updateuserinfo().then((value) {
                            _showMessage(context, 'Updated Successfully');
                          });
                        }
                      },
                      icon: Icon(Icons.edit,size: 28,),
                      label: Text('UPDATE',style: TextStyle(fontSize: 16),),
                  )

                ],
              ),
            ),
          ),
        )
      ),
    );
  }
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(message)),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.blue.withOpacity(0.8),
      ),
    );
  }
    void _showbottomsheet(){
      showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
          ),
          builder: (_){
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: mq.height*0.03,bottom: mq.height*0.05),
          children: [
            Text('Pick Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.w500),),
            SizedBox(height: mq.height*0.02,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                      if(image != null){
                          setState(() {
                            _image = image.path;
                          });
                          API.updateprofilepicture(File(_image!));
                          Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.white,
                      shape: CircleBorder(),
                      fixedSize: Size(mq.width*0.2, mq.height*0.1)
                    ),
                    child:Image.asset('assets/add_image.png')
                ),
                ElevatedButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image = await picker.pickImage(source: ImageSource.camera , imageQuality: 80);
                      if(image != null){
                        setState(() {
                          _image = image.path;
                        });
                        API.updateprofilepicture(File(_image!));
                        Navigator.pop(context);
                      }

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.white,
                        shape: CircleBorder(),
                        fixedSize: Size(mq.width*0.2, mq.height*0.1 )
                    ),
                    child:Image.asset('assets/camera.png')
                ),

              ],
            )
          ],
        );
      });
    }

}

