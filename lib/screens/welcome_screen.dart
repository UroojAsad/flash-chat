import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/components/round_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id ='welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller=AnimationController(duration:Duration(seconds: 1),
        vsync: this);

    animation=ColorTween(begin: Colors.blueGrey , end: Colors.white).animate(controller);

    controller.forward();

    controller.addListener((){
      setState(() {
        print(animation.value);
      });
    });
  }

  @override
  void dispose() {
   controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:animation.value  ,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(onpress:(){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return LoginScreen();
              }));
            },
            colour: Colors.lightBlueAccent, tittle: 'Log In',
            ),
           RoundButton(colour:Colors.blueAccent,
             tittle: 'Register',
             onpress: () {
             Navigator.push(context, MaterialPageRoute(builder: (context){
               return RegistrationScreen();
             }));
           },),
          ],
        ),
      ),
    );
  }
}

