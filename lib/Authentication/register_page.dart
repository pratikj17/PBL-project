import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pbl/APIS/apis.dart';
import 'package:pbl/functions/Textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({Key? key, this.onTap,  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller=TextEditingController();
  final passwordcontroller=TextEditingController();
  final usernamecontroller=TextEditingController();
  final socialmediacontroller=TextEditingController();
  final instrumentcontroller=TextEditingController();
  final locsationcontroller=TextEditingController();

  final user=FirebaseAuth.instance.currentUser;

  Future<void> signuserUp() async {
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //create user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);

    }on FirebaseAuthException catch(e){
      if(e.code=='user-not-found'){
        Navigator.pop(context);
        wronglmessage();
      }
      else if(e.code=='wrong-password'){
        Navigator.pop(context);
        wronglmessage();
      }
    }

    API.createUser(usernamecontroller.text, emailcontroller.text, socialmediacontroller.text, instrumentcontroller.text, locsationcontroller.text);

    Navigator.pop(context);
  }
  void wronglmessage(){
    showDialog(
        context:context,
        builder:(context){
          return const AlertDialog(title: Text('Ivalid email or password'),);
        }
    );
  }

  // Future addUserDetails(String username,String instaid,String instruments,String location,String useremail) async {
  //   await FirebaseFirestore.instance.collection('Users').add({
  //     'username':username,
  //     'instaid':instaid,
  //     'instruments':instruments,
  //     'location':location,
  //     'email':useremail,
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child:Padding(
            padding: EdgeInsets.all(12.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //logo
                    MyTextfield(controller: emailcontroller,hinttext: 'xyz@gmail.com',obscuretext: false,labelTexT: 'Email',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: passwordcontroller,hinttext: 'Password',obscuretext: true,labelTexT: 'Password',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: usernamecontroller,hinttext: 'XYZ',obscuretext: false,labelTexT: 'username',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: socialmediacontroller,hinttext: 'social media',obscuretext: false,labelTexT: 'social_media',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: instrumentcontroller,hinttext: 'instrument played',obscuretext: false,labelTexT: 'intrument',),
                    const SizedBox(height: 9,),
                    MyTextfield(controller: locsationcontroller,hinttext: 'Country/City',obscuretext: false,labelTexT: 'City',),
                    const SizedBox(height: 9,),


                    const SizedBox(height: 25,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: (){
                          signuserUp();
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder:(_)=>() ));
                        },
                        child: Text('SignUp',style: TextStyle(color: Colors.white,fontSize: 20),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height:50 ,),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.black38,)),
                        Text('Or Continue With'),
                        Expanded(child: Divider(color: Colors.black38,))
                      ],
                    ),
                    const SizedBox(height: 50,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        const SizedBox(width: 4,),
                        GestureDetector(
                            onTap:widget.onTap,
                            child: Text('Login',
                              style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )

    );
  }
}
