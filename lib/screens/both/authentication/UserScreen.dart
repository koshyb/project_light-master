import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectlight/tools/Firebase.dart';

import 'LoginScreen.dart';

class UserScreen extends StatefulWidget {
  static const String id = 'userScreen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
//  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Project Light'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.exit_to_app),
            onPressed: () {
              /// TODO ask if you want to logout
              FirebaseTools().signOut();
              Navigator.popAndPushNamed(context, LoginScreen.id);
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          /// -- User details section --
          Text(
            'User details',
            style:
                GoogleFonts.ptSerif(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Email: '),
                Divider(),
                FlatButton(
                    onPressed: () => null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text('Update password'),
                        Icon(Icons.arrow_forward)
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
