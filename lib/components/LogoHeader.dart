import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'App Logo',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.transparent,
          radius: 40.0,
          child: ClipOval(
            child: Image.asset(
              'images/logo.png',
              fit: BoxFit.cover,
              width: 100.0,
              height: 100.0,
            ),
          )),
    );
  }
}
