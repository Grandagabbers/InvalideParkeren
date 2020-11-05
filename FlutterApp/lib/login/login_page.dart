import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static String tag = "login_page";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue: "test@gmail.com",
      decoration: InputDecoration(
        hintText: "E-mail",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
    );

    final password = TextFormField(
      autofocus: false,
      initialValue: "some password",
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: (){
            
          },
        color: Colors.lightBlueAccent,
        child: Text("Log in", style: TextStyle(color: Colors.white),),
      )));


    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            email,
            SizedBox(height: 5.0),
            password,
            SizedBox(height: 5.0),
            loginButton,
            SizedBox(height: 5.0),
          ],
        ))
      
    );
  }
}