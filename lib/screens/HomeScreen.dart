import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbl/screens/add_screen.dart';

import '../APIS/apis.dart';
import '../functions/Navbar.dart';
import '../widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selfInfo();
  }

  Future<void> _selfInfo() async {
    // setState(() {
    //   _isLoading = true; // Set loading state
    // });
    try {
      await API.getselfinfo().then((value) => setState(() {
        _isLoading = false; // Set loading state
      }));

    } catch (e) {
      // Handle error
      print("Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer:_isLoading
          ? Center(child: CircularProgressIndicator())
          : Navbar(user: API.me) ,
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Container(
            color: Colors.grey,
            height: 0.5,
          ),
        ),
        title: const Text('Home'),
        centerTitle: true,
        // leading: IconButton(
        //   onPressed: (){
        //
        //   },
        //   icon: const Icon(Icons.camera_alt_outlined),
        // ),

      ),

      body: _isLoading? Center(child: CircularProgressIndicator()) :CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(API.me.id)
                .collection('posts')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return PostWidget(snapshot.data!.docs[index].data());
                  },
                  childCount:
                  snapshot.data == null ? 0 : snapshot.data!.docs.length,
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=>AddScreen()));
        },
        child: const Icon(Icons.add),
      ),

      );

  }
}
