import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projectlight/components/IOSorAndroidComponents.dart';
import 'package:projectlight/validation/Validator.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class RegistrationMarriage extends StatefulWidget {
  static const String id = 'RegistrationMarriage';

  @override
  _RegistrationMarriageState createState() => _RegistrationMarriageState();
}

class _RegistrationMarriageState extends State<RegistrationMarriage> {
  String phoneNo;
  String smsCode;
  String verificationID;

  bool codeSent = false;

  String _firstName;
  String _lastName;
  String _age;
  String _location;
  String _phoneNumber;

  List<String> dropDownItems = ['Please Select', 'Male', 'Female'];
  String dropDownValue = 'Please Select';
  List<String> dropDownItems2 = [
    'Please Select',
    'Atheist',
    'Buddhism',
    'Christianity',
    'Hinduism',
    'Islam',
    'Sikhism',
    'Judaism',
    'Prefer not to say',
  ];
  String dropDownValue2 = 'Please Select';

  IOSorAndroidComponents deviceComponents = IOSorAndroidComponents();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final TextEditingController _controller = new TextEditingController();

  Widget _buildGender() {
    return deviceComponents.dropDownList(dropDownItems, dropDownValue, (value) {
      print('Chosen $value');
      setState(() {
        dropDownValue = value;
      });
    });
  }

  Widget _buildReligion() {
    return deviceComponents.dropDownList(dropDownItems2, dropDownValue2,
        (value) {
      print('Chosen $value');
      setState(() {
        dropDownValue2 = value;
      });
    });
  }

  Widget _buildFirstName() {
    return FormBuilderTextField(
        decoration: InputDecoration(labelText: 'First Name'),
        keyboardType: TextInputType.text,
        validators: [
          FormBuilderValidators.required(errorText: "Invalid Character")
        ]);
  }

  Widget _buildLastName() {
    return FormBuilderTextField(
        decoration: InputDecoration(labelText: 'Last Name'),
        keyboardType: TextInputType.text,
        validators: [
          FormBuilderValidators.required(errorText: "Invalid Character")
        ]);
  }

  Future _buildAge(BuildContext context, String initialDateString) async {
    return deviceComponents.ageDatePickerDialog(
        context: context,
        saveChosenDateMethod: (result) {
          if (result == null) return;
          setState(() {
            _controller.text = DateFormat('d/M/y').format(result);
          });
        });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat('d/M/y').parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidDob(String dob) {
    if (dob.isNotEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  Widget _buildLocation() {
    return FormBuilderTextField(
        decoration: InputDecoration(labelText: 'Location'),
        keyboardType: TextInputType.text,
        validators: [
          FormBuilderValidators.required(errorText: "Invalid Character")
        ]);
  }

  Future<void> _buildPhoneNumber(phoneNo) async {
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential result) {
      print('verified $result');
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException exception) {
      print('${exception.message}');
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
    };
    setState(() {
      this.codeSent = true;
    });

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationID = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      codeAutoRetrievalTimeout: autoTimeout,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 10),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiedFailed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
        title: Text('Project-Light'),
      ),
      body: FormBuilder(
        key: _fbKey,
        initialValue: {
          'date': DateTime.now(),
          'accept_terms': false,
        },
        autovalidate: false,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            _buildGender(),
            _buildReligion(),
            _buildFirstName(),
            _buildLastName(),
            TextFormField(
              decoration: const InputDecoration(
                icon: const Icon(Icons.calendar_today),
                hintText: 'D.O.B',
                labelText: 'Date of Birth',
              ),
              controller: _controller,
              keyboardType: TextInputType.datetime,
              validator: (val) => isValidDob(val) ? null : 'Not a valid date',
              onSaved: (val) => convertToDate(val),
            ),
            FlatButton(
                color: Colors.white,
                child: Text(
                  'Choose from Calender',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  _buildAge(context, _controller.text);
                }),
            _buildLocation(),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: 'Enter Phone Number'),
              onChanged: (value) {
                setState(() {
                  this.phoneNo = value;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: RaisedButton(
                child: Center(
                  child: Text('Verify'),
                ),
                onPressed: () {
                  _buildPhoneNumber(phoneNo);
                },
              ),
            ),
            /*codeSent
                ? TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration:
                        InputDecoration(hintText: 'Enter Code Received'),
                    onChanged: (value) {
                      setState(() {
                        this.smsCode = value;
                      });
                    },
                  )
                : Container(),*/
            /*SizedBox(height: 10.0),
            RaisedButton(
                child: Text(
                  'Verify',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  _buildPhoneNumber();
                }),*/
            SizedBox(height: 100),
            RaisedButton(
              color: Colors.white,
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              onPressed: () {
                if (!_fbKey.currentState.saveAndValidate()) {
                  print(_fbKey.currentState.value);
                  //return;
                }

                print(_firstName);
              },
            )
          ],
        ),
      ),
    );
  }
}
