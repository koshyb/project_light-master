import 'package:flutter/material.dart';
import 'package:projectlight/components/ComponentsPackage.dart';

class DatingUserDetailsScreen extends StatefulWidget {
  static const String id = 'datingUserDetailsScreen';

  @override
  _DatingUserDetailsScreenState createState() =>
      _DatingUserDetailsScreenState();
}

class _DatingUserDetailsScreenState extends State<DatingUserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: ComponentsPackage(context).simpleAppBar(),
      body: ListView(
        children: <Widget>[Text('User details')],
      ),
    ));
  }
}
