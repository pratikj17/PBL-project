import 'package:flutter/material.dart';
import 'package:pbl/Authentication/LoginPage.dart';
import 'package:pbl/Authentication/register_page.dart';

class LoginorRegisterPage extends StatefulWidget {
  LoginorRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginorRegisterPage> createState() => _LoginorRegisterPageState();
}

class _LoginorRegisterPageState extends State<LoginorRegisterPage> {
  bool showloginpage=true;

  void togglepages(){
    setState(() {
      showloginpage=!showloginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showloginpage){
      return LoginPage(
        onTap: togglepages,
      );
    }
    else{
      return RegisterPage(onTap: togglepages,);
    }
  }
}
