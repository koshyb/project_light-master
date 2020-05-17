import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSorAndroidComponents {
  /// Loading indicator
  Widget loadingIndicator() {
    if (Platform.isAndroid) {
      return CircularProgressIndicator();
    } else if (Platform.isIOS) {
      // TODO Need testing
      return CupertinoActivityIndicator(
//        radius: ,
          );
    } else {
      return CircularProgressIndicator();
    }
  }

  //  DateTime chosenBirthDay;
  //FlatButton(
  //                  onPressed: () {
  //                    IOSorAndroidComponents().ageDatePickerDialog(
  //                        context: context,
  //                        saveChosenDateMethod: (date) {
  //                          setState(() {
  //                            chosenBirthDay = date;
  //                          });
  //                          print(chosenBirthDay);
  //                        });
  //                  },
  //                  child: Text('Test dateTime'))
  Future ageDatePickerDialog(
      {BuildContext context, Function saveChosenDateMethod}) async {
    if (Platform.isIOS) {
      return showCupertinoDialog(
          context: context,
          builder: (_) => Container(
                child: CupertinoDatePicker(
                    initialDateTime: DateTime(DateTime.now().year - 18),
                    minimumDate: DateTime(DateTime.now().year - 80),
                    maximumDate: DateTime(DateTime.now().year - 18),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: saveChosenDateMethod),
              ));
    } else {
      var date = await datetime(context);
      saveChosenDateMethod(date);
    }
  }

  Future<DateTime> datetime(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 18),
      firstDate: DateTime(DateTime.now().year - 80),
      lastDate: DateTime(DateTime.now().year - 18),
    );
  }

  /// Drop down list
  Widget dropDownList(
      List<String> items, String dropDownValue, Function onChange) {
    if (Platform.isIOS) {
      return CupertinoPicker(
          // TODO NEED TESTING
          itemExtent: 10,
          onSelectedItemChanged: onChange,
          children: items.map((value) => Text(value)).toList());
    } else {
      List<DropdownMenuItem> sortByOptionsList =
          items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
      return DropdownButton(
          hint: Text('Please select type'),
          value: dropDownValue,
          items: sortByOptionsList,
          onChanged: onChange);
    }
  }

  Future alertWarningDialog({String title, BuildContext context}) {
    if (Platform.isIOS) {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => CupertinoAlertDialog(
          title: Text(title),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            )
          ],
        ),
      );
    } else {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          title: Text(title),
          elevation: 20,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
