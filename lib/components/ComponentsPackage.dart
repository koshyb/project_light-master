import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectlight/dev/Log.dart';

class ComponentsPackage {
  final log = Log().logger;
  final BuildContext context;

  ComponentsPackage(this.context);

  /// Simple basic appbar
  Widget simpleAppBar() {
    return AppBar(
      title: Text(
        'Project Light',
        style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  /// Text field with button
  Widget textFieldButton(
      TextEditingController controller,
      Function setStateTextField,
      Function setStateButton,
      Function clearButton,
      String hintText,
      Icon icon) {
    return Row(
      children: <Widget>[
        Expanded(
          child: new Stack(
              alignment: const Alignment(1.0, 1.0),
              children: <Widget>[
                new TextField(
                  decoration: InputDecoration(hintText: hintText),
                  onChanged: setStateTextField,
                  controller: controller,
                ),
                controller.text.length > 0
                    ? new IconButton(
                        icon: new Icon(Icons.clear), onPressed: clearButton)
                    : new Container(
                        height: 0.0,
                      )
              ]),
        ),
        RaisedButton(
          onPressed: setStateButton,
          child: icon,
        )
      ],
    );
  }
}
