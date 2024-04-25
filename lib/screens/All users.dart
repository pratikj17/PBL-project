import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl/APIS/apis.dart';
import 'package:pbl/functions/Navbar.dart';
import 'package:pbl/main.dart';
import 'package:pbl/models/ChatUser.dart';
import 'package:pbl/widgets/chat_user%20card.dart';
class AllUsers extends StatefulWidget {
  AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {

  List<ChatUser> _list = [];
  final List<ChatUser> _searchlist = [];
  bool _isSearching = false;
  final user = FirebaseAuth.instance.currentUser!;
  bool _isLoading = true;
  bool _showdrawer=true;

  @override
  void initState() {
    super.initState();
    _selfInfo();
  }


  Future<void> _selfInfo() async {
    setState(() {
      _isLoading = true; // Set loading state
    });
    try {
      await API.getselfinfo();
    } catch (e) {
      // Handle error
      print("Error fetching user: $e");
    } finally {
      setState(() {
        _isLoading = false; // Set loading state
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(

        drawer: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _showdrawer? Navbar(user: API.me):null,
        appBar: AppBar(
          title: _isSearching ?
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name,Email...",
            ),

            autofocus: true,
            style: TextStyle(fontSize: 17,letterSpacing: 0.5),
            //When searched update search list
            onChanged: (val){
              //search logic
              _searchlist.clear();
              for(var i in _list){
                if(i.username.toLowerCase().contains(val.toLowerCase()) ||
                    i.email.toLowerCase().contains(val.toLowerCase()) ||
                    i.instruments.toLowerCase().contains(val.toLowerCase()) ||
                    i.location.toLowerCase().contains(val.toLowerCase())
                )
                {
                  _searchlist.add(i);
                }//if
                setState(() {
                  _searchlist;
                });
              }//for
            },//onchanged
          )
              :Center(child: Text('Explore')),
          actions: [
            IconButton(
                onPressed: (){
                  setState(() {
                    _showdrawer=!_showdrawer;
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid:Icons.search))
          ],
        ),
        body: StreamBuilder(
          stream: API.getallusers(),
          builder: (context,snapshot){
            switch(snapshot.connectionState){
            //if data is loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

            //if some or all data is loaded then show it
              case ConnectionState.active:
              case ConnectionState.done:

                final data=snapshot.data?.docs;
                _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
                if(_list.isNotEmpty){
                  return ListView.builder(
                      itemCount:_isSearching ? _searchlist.length : _list.length,
                      padding: EdgeInsets.only(top:mq.height*0.01),
                      itemBuilder: (context,index){
                        return ChatUserCard(user: _isSearching ? _searchlist[index] : _list[index]);
                      });
                }
                else{
                  return Center(child: Text('No Connections Found!',style: TextStyle(fontSize: 20),));
                }

            }

          },
        ),
      ),
    );
  }
}

