import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pbl/APIS/apis.dart';
import 'package:pbl/models/ChatUser.dart';
import 'package:pbl/models/usermodel.dart';
import 'package:pbl/screens/Edit_profile.dart';
import 'package:pbl/screens/post_screen.dart';

import 'ChatUserScreen.dart';

class ProfileScreen extends StatefulWidget {
  String Uid;
  ProfileScreen({super.key, required this.Uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  int post_lenght = 0;
  bool yourse = false;
  List following = [];
  bool follow = false;
  late ChatUser thisuser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    if (widget.Uid == API.user.uid) {
      setState(() {
        yourse = true;
      });
    }
    getthisuser();
  }

  getthisuser() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('Users')
        .doc(widget.Uid)
        .get();
    thisuser = ChatUser(
      id: snap.id,
      username: snap['username'],
      image: snap['image'],
      email: snap['email'],
      followers: snap['followers'],
      following: snap['following'],
      group: snap['group'],
      instaid: snap['instaid'],
      instruments: snap['instruments'],
      location: snap['location'],
    );
  }

  getdata() async {
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('Users')
        .doc(API.user.uid)
        .get();
    following = (snap.data()! as dynamic)['following'];
    if (following.contains(widget.Uid)) {
      setState(() {
        follow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FutureBuilder(
                  future: API().getUser(UID: widget.Uid),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Head(snapshot.data!);
                  },
                ),
              ),
              StreamBuilder(
                stream: _firebaseFirestore
                    .collection('posts')
                    .where('uid', isEqualTo: widget.Uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                        child:
                        const Center(child: CircularProgressIndicator()));
                  }
                  post_lenght = snapshot.data!.docs.length;
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final snap = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PostScreen(snap.data())));
                        },
                        child:CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: snap['postImage'],
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
                      );
                    }, childCount: post_lenght),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Head(Usermodel user) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
                child: ClipOval(
                  child: SizedBox(
                    width: 80.w,
                    height: 80.h,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: user.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 35.w),
                      Text(
                        post_lenght.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 53.w),
                      Text(
                        user.followers.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(width: 70.w),
                      Text(
                        user.following.length.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 30.w),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 25.w),
                      Text(
                        'Followers',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 19.w),
                      Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " "+user.username,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                // Text(
                //   user.bio,
                //   style: TextStyle(
                //     fontSize: 12.sp,
                //     fontWeight: FontWeight.w300,
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Visibility(
            visible: !follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: GestureDetector(
                onTap: () {
                  if (yourse == false) {
                    API().flollow(uid: widget.Uid);
                    setState(() {
                      follow = true;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: yourse ? Colors.white : Colors.blue,
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                        color: yourse ? Colors.grey.shade400 : Colors.blue),
                  ),
                  child: yourse
                      ? Container(
                            width: double.infinity,
                            height: 28,
                            child: ElevatedButton(
                                onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfile(user: API.me)));
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>() ));
                                },
                                child: Text('Edit Profile',style: TextStyle(color: Colors.white,fontSize: 20),),
                                    style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    )
                                ),
                            ),
                      )
                      : Text(
                    'Follow',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: follow,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      API().flollow(uid: widget.Uid);
                      setState(() {
                        follow = false;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 30.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text('Unfollow')),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(user:thisuser)),);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        'Message',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            width: double.infinity,
            //height: 35.h,
            child: const TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Icon(Icons.grid_on),
                Icon(Icons.video_collection),
                Icon(Icons.person),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}
