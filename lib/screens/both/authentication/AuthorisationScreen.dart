import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectlight/components/ComponentsPackage.dart';
import 'package:projectlight/components/IOSorAndroidComponents.dart';
import 'LoginScreen.dart';
import 'UserScreen.dart';

/// Ref: https://medium.com/coding-with-flutter/super-simple-authentication-flow-with-flutter-firebase-737bba04924c

class AuthorisationScreen extends StatefulWidget {
  final Function goToScreen;
  static const String id = 'authorisationScreen';

  const AuthorisationScreen({this.goToScreen});

  @override
  _AuthorisationScreenState createState() => _AuthorisationScreenState();
}

class _AuthorisationScreenState extends State<AuthorisationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
//          print('user is live ${user}');
//          print('current user is $currentUser');
          if (user == null) {
            return LoginScreen();
          } else {
            if (widget.goToScreen == null) {
//              print('go to screen null');
              return UserScreen();
            } else {
              return widget.goToScreen();
            }
          }
        } else {
          return Scaffold(
            appBar: ComponentsPackage(context).simpleAppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: IOSorAndroidComponents().loadingIndicator(),
                ),
                Center(
                    child: Text(
                        'Please make sure you are connected to data or WIFI'))
              ],
            ),
          );
        }
      },
    );
  }
}
