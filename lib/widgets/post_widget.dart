import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_format/date_format.dart';
import 'package:pbl/screens/Profile.dart';

import '../APIS/apis.dart';
import 'like_animation.dart';

class PostWidget extends StatefulWidget {
  final snapshot;
  PostWidget(this.snapshot, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  bool isAnimating = false;
  String user = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser!.uid;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(Uid: widget.snapshot['uid'],),
              ),
            );
          },
          child: Container(
            width: 375.w,
            height: 54.h,
            color: Colors.white,
            child: Center(
              child: ListTile(
                leading: ClipOval(
                  child: SizedBox(
                    width: 35.w,
                    height: 35.h,
                    child:  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: widget.snapshot['image'] ?? 'default_image_url',
                    errorWidget: (context, url, error) => const CircleAvatar(child: Icon( Icons.person),),
                    progressIndicatorBuilder: (context, url, progress) {
                      return Container(
                        child: Padding(
                          padding: EdgeInsets.all(130.h),
                          child: CircularProgressIndicator(
                            value: progress.progress,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                    // errorWidget: (context, url, error) => Container(
                    //   color: Colors.amber,
                    // ),
                  ),
                  ),
                ),
                title: Text(
                  widget.snapshot['username'],
                  style: TextStyle(fontSize: 20.sp),
                ),
                trailing: const Icon(Icons.more_horiz),
              ),
            ),
          ),
        ),
        GestureDetector(
          onDoubleTap: () {
            API().like(
                like: widget.snapshot['like'],
                type: 'posts',
                uid: user,
                postId: widget.snapshot['postId']);
            setState(() {
              isAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 375.w,
                height: 375.h,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: widget.snapshot['postImage'] ?? 'default_image_url',
                  progressIndicatorBuilder: (context, url, progress) {
                    return Container(
                      child: Padding(
                        padding: EdgeInsets.all(130.h),
                        child: CircularProgressIndicator(
                          value: progress.progress,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) => Container(
                    color: Colors.amber,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: Icon(
                    Icons.favorite,
                    size: 100.w,
                    color: Colors.red,
                  ),
                  isAnimating: isAnimating,
                  duration: Duration(milliseconds: 400),
                  iconlike: false,
                  End: () {
                    setState(() {
                      isAnimating = false;
                    });
                  },
                ),
              )

            ],
          ),
        ),
        Container(
          width: 375.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 14.h),
              Row(
                children: [
                  SizedBox(width: 14.w),
                  LikeAnimation(
                    isAnimating: widget.snapshot['like'].contains(user),
                    child: IconButton(
                      onPressed: () {
                        API().like(
                            like: widget.snapshot['like'],
                            type: 'posts',
                            uid: user,
                            postId: widget.snapshot['postId']);
                      },
                      icon: Icon(
                        widget.snapshot['like'].contains(user)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.snapshot['like'].contains(user)
                            ? Colors.red
                            : Colors.black,
                        size: 24.w,
                      ),
                    ),
                  ),
                  // SizedBox(width: 17.w),
                  // GestureDetector(
                  //   onTap: () {
                  //     showBottomSheet(
                  //       backgroundColor: Colors.transparent,
                  //       context: context,
                  //       builder: (context) {
                  //         return Padding(
                  //           padding: EdgeInsets.only(
                  //             bottom: MediaQuery.of(context).viewInsets.bottom,
                  //           ),
                  //           child: DraggableScrollableSheet(
                  //             maxChildSize: 0.6,
                  //             initialChildSize: 0.6,
                  //             minChildSize: 0.2,
                  //             builder: (context, scrollController) {
                  //               return Comment(
                  //                   'posts', widget.snapshot['postId']);
                  //             },
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Image.asset(
                  //     'images/comment.webp',
                  //     height: 28.h,
                  //   ),
                  // ),
                  // SizedBox(width: 17.w),
                  // Image.asset(
                  //   'images/send.jpg',
                  //   height: 28.h,
                  // ),
                  // const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Icon(
                      Icons.bookmark_border,
                      size: 24.w,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 30.w,
                  // top: 4.h,
                  bottom: 8.h,
                ),
                child: Text(
                  widget.snapshot['like'].length.toString(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text(
                      widget.snapshot['username'],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold, // Set fontWeight to bold for the username
                      ),
                    ),
                    SizedBox(width: 8), // Add spacing between username and caption
                    Expanded(
                      child: Text(
                        ':  ' + widget.snapshot['caption'],
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal, // Set fontWeight to normal for the caption
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 20.h, bottom: 8.h),
                child: Text(
                  formatDate(widget.snapshot['time'].toDate(),
                      [yyyy, '-', mm, '-', dd]),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
