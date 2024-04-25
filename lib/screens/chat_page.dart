import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pbl/APIS/apis.dart';
import 'package:pbl/functions/Navbar.dart';
import 'package:pbl/main.dart';
import 'package:pbl/models/ChatUser.dart';
import 'package:pbl/widgets/chat_user%20card.dart';
import 'package:pbl/screens/All users.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  List<ChatUser> _list = [];
  final List<ChatUser> _searchlist = [];
  bool _isSearching = false;
  final user = FirebaseAuth.instance.currentUser!;
  bool _showdrawer=true;

  @override
  void initState() {
    super.initState();
    // _selfInfo();
  }


  // Future<void> _selfInfo() async {
  //   setState(() {
  //     _isLoading = true; // Set loading state
  //   });
  //   try {
  //     await API.getselfinfo();
  //   } catch (e) {
  //     // Handle error
  //     print("Error fetching user: $e");
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // Set loading state
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return  GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: Container(
              color: Colors.grey,
              height: 0.5,
            ),
          ),
          title: _isSearching ?
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name,Email...",
                  prefixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                      _showdrawer=!_showdrawer;
                      _isSearching = !_isSearching;
                    }); },
                    icon: Icon(Icons.arrow_back),)
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
              :Text('Chat'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: (){
                  setState(() {
                    _showdrawer=!_showdrawer;
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching ? CupertinoIcons.clear:Icons.search,size: 20,))
          ],

        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>AllUsers()));
          },
          child: const Icon(Icons.people),
        ),
        body: StreamBuilder(
          stream: API.getmyUsersId(),
          builder: (context,snapshot){
              return StreamBuilder(
                stream: API.getmyusers(
                    snapshot.data?.docs.map((e) => e.id).toList() ??[]
                ),
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
              );

          },
        ),
        // bottomNavigationBar:BottomNavBar()
      ),
    );
  }


}

