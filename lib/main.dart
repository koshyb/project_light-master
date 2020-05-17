import 'package:flutter/material.dart';
import 'package:projectlight/screens/both/authentication/LoginScreen.dart';
import 'package:projectlight/screens/both/authentication/RegisterScreen.dart';
import 'package:projectlight/screens/both/camera/CameraScreen.dart';
import 'package:projectlight/screens/dating/DatingUserDetailsScreen.dart';
import 'package:projectlight/screens/marriage/registration-marriage.dart';

import 'screens/both/authentication/AuthorisationScreen.dart';
import 'screens/both/authentication/ForgotPasswordScreen.dart';

bool marriageUser;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.white),
        initialRoute: RegistrationMarriage.id,
        debugShowCheckedModeBanner: false,
        routes: {
          CameraScreen.id: (context) => CameraScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          AuthorisationScreen.id: (context) => AuthorisationScreen(),
          ForgotPasswordScreen.id: (context) => ForgotPasswordScreen(),
          DatingUserDetailsScreen.id: (context) => DatingUserDetailsScreen(),
          RegistrationMarriage.id: (context) => RegistrationMarriage(),
        });
  }
}
