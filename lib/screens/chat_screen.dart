import 'package:flutter/material.dart';
import 'package:flashchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs.reversed.toList();
                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    var messageData = message.data() as Map<String, dynamic>;
                    final messageText = messageData['text'] ?? '';
                    final messageSender = messageData['sender'] ?? '';

                    final currentUser = loggedInUser?.email;
                    if(currentUser == messageSender){
                      //the message from the logged in user
                    }

                     final messageBubble = BubbleButton(
                         messageText: messageText,
                         messageSender: messageSender,
                       isme: currentUser == messageSender,);
                    messageWidgets.add(messageBubble);
                  }

                  return ListView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: messageWidgets,
                  );
                },
              ),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      if (messageText.isNotEmpty) {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser!.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                        messageText = ''; // Clear the input field
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleButton extends StatelessWidget {
    BubbleButton({required this.messageText, required this.messageSender, required this.isme,});

  final  messageText;
  final  messageSender;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isme? CrossAxisAlignment.end : CrossAxisAlignment.start ,
        children: [
          Text(messageSender,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12.0,),),
          Material(
            borderRadius:  isme? BorderRadius.only(
              topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)):
            BorderRadius.only(
              topRight : Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),),
            elevation: 5.0,
            color: isme ? Colors.lightBlueAccent : Colors.white ,
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                 '$messageText',
                 style: TextStyle(fontSize: 15.0,
                 color: isme? Colors.white :Colors.black54),
               ),
            ),

          ),
        ],
      ),
    );
  }
}

