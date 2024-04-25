import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pbl/main.dart';
import 'package:pbl/models/ChatUser.dart';
import 'package:pbl/screens/view_user_profile.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({Key? key, required this.user}) : super(key: key);
  final ChatUser user;
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: mq.width*0.6,
        height: mq.height*0.35,
        child: Stack(
          children : [
            Positioned(
                width: mq.width*0.55,
                child: Text(user.username,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),)),
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height*0.25),
                child: CachedNetworkImage(
                  width: mq.height*0.27,
                  height: mq.height*0.27,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(child: Icon( Icons.person),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
