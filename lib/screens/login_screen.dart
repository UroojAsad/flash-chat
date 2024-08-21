import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class LoginScreen extends StatefulWidget {
  static const String id ='login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
String email='';
String password='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(

        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                    email=value;              },
                decoration: kTextFieldInputDecoratuion.copyWith(hintText: 'Enter your email',),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(

                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                password=value;              },
                decoration: kTextFieldInputDecoratuion.copyWith(  hintText: 'Enter your password.',),
              ),
              SizedBox(
                height: 24.0,
              ),
          RoundButton(onpress:() async{
            setState(() {
              showSpinner=true;
            });
            try {
              final User = await _auth.signInWithEmailAndPassword(email: email, password: password);
              if(User!=null){
                Navigator.pushNamed(context, ChatScreen.id);
              }
              setState(() {
                showSpinner=false;
              });
            }


            catch (e) {
              print(e);
            };
          },
            colour: Colors.lightBlueAccent, tittle: 'Log In',
          ),
            ],
          ),
        ),
      ),
    );
  }
}
