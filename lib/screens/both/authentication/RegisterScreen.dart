import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projectlight/components/ComponentsPackage.dart';
import 'package:projectlight/components/FormInputFieldWithIcon.dart';
import 'package:projectlight/components/IOSorAndroidComponents.dart';
import 'package:projectlight/components/LogoHeader.dart';
import 'package:projectlight/main.dart';
import 'package:projectlight/screens/both/authentication/AuthorisationScreen.dart';
import 'package:projectlight/screens/dating/DatingUserDetailsScreen.dart';
import 'package:projectlight/tools/Firebase.dart';
import 'package:projectlight/tools/HTTPRequestHelper.dart';
import 'package:projectlight/validation/Validator.dart';

import 'LoginScreen.dart';
import 'UserScreen.dart';

/// Ref: https://github.com/delay/flutter_firebase_auth_starter
class RegisterScreen extends StatefulWidget {
  static const String id = 'registerScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _emailUsed = false;
  bool _loading = false;
  int _radioValue = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  @override
  void initState() {
    super.initState();
    HTTPRequestHelper().checkPhoneSettingFirst(context);
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: ComponentsPackage(context).simpleAppBar(),
      body: ModalProgressHUD(
        child: Container(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          /// -- LOGO section ---
                          LogoHeader(),
                          SizedBox(),
                          Center(
                              child: Text(
                            'Create a new account',
                            style: GoogleFonts.lato(fontSize: 18),
                          )),
                          SizedBox(height: 10.0),

                          /// -- Email section --
                          FormInputFieldWithIcon(
                            controller: _email,
                            iconPrefix: Icons.email,
                            labelText: 'Email',
                            maxLength: 50,
                            validator: Validator().email,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) => null,
                            onSaved: (value) => _email.text = value,
                          ),
                          _emailUsed
                              ? Text(
                                  'Email already registered',
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox(),
                          SizedBox(),

                          /// -- Password section --
                          new FormInputFieldWithIcon(
                            controller: _password,
                            iconPrefix: Icons.lock,
                            labelText: 'Password',
                            maxLength: 20,
                            validator: Validator().password,
                            obscureText: true,
                            maxLines: 1,
                            onChanged: (value) => null,
                            onSaved: (value) => _password.text = value,
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          /// -- Choose plan --
                          Text(
                            'What service would you like to use?',
                            style: GoogleFonts.notoSans(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: <Widget>[
                              Text('Dating:'),
                              Radio(
                                value: 0,
                                groupValue: _radioValue,
                                onChanged: _handleRadioValueChange,
                              ),
                              Spacer(),
                              Text('Marriage:'),
                              new Radio(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: _handleRadioValueChange,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              'By clicking on sign up below, I agree to the Terms of Use and have read the Privacy Statement.'),
                          SizedBox(
                            height: 5,
                          ),

                          /// -- Sign up button --
                          RaisedButton(
                              color: Colors.redAccent,
                              padding: EdgeInsets.all(22),
                              child: Text(
                                'CREATE ACCOUNT',
                                style: GoogleFonts.lato(
                                    fontSize: 18, color: Colors.white),
                              ),
                              onPressed: () async {
                                bool connected = await HTTPRequestHelper
                                    .checkIfConnectedToWeb();
                                HTTPRequestHelper()
                                    .checkPhoneSettingFirst(context);
                                if (_formKey.currentState.validate() &&
                                    connected) {
                                  String registerMessage =
                                      'Failed to create account, try again!';
                                  FocusScope.of(context).unfocus();

                                  setState(() {
                                    _loading = true;
                                  });

                                  FirebaseTools firebase = FirebaseTools();
                                  print(_email.text.trim());
                                  print(_password.text.trim());

                                  /// Create account
                                  String result = await firebase.register(
                                      email: _email.text.trim(),
                                      password: _password.text.trim());

                                  /// Created account
                                  if (result != null &&
                                      result.contains('Success')) {
                                    /// Now login
                                    String loginResult = await firebase.login(
                                        email: _email.text.trim(),
                                        password: _password.text.trim());
                                    print('final result is $result');

                                    /// Logged in successfully
                                    if (loginResult != null &&
                                        loginResult.contains('Success')) {
                                      setState(() {
                                        _loading = false;
                                      });
                                      print('login success');
                                      if (_radioValue == 0) {
                                        marriageUser = false;

                                        /// Go to dating user details form
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AuthorisationScreen(
                                                      goToScreen: () =>
                                                          DatingUserDetailsScreen(),
                                                    )),
                                            (r) => false);
                                      } else {
                                        marriageUser = true;

                                        /// TODO connect to bibins marriage user details
                                      }
                                    } else {
                                      setState(() {
                                        _loading = false;
                                      });
                                      print('login fail');
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          LoginScreen.id, (r) => false);
                                    }
                                  } else {
                                    setState(() {
                                      _loading = false;

                                      /// If google error
                                      if (firebase.error != null &&
                                          firebase.error.length > 0)
                                        registerMessage = firebase.error;
                                    });
                                    IOSorAndroidComponents().alertWarningDialog(
                                        title: registerMessage,
                                        context: context);
                                    _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                            content: Text(registerMessage)));
                                  }
                                }
                              }),
                          Divider(
                            height: 20,
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, LoginScreen.id);
                              },
                              child: Text('Already have a account? Login')),
                        ],
                      ),
                    ),
                  ),
                ))),
        inAsyncCall: _loading,
        progressIndicator: IOSorAndroidComponents().loadingIndicator(),
      ),
    ));
  }

  /// Radio button to decide dating or marriage
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      print(value);
    });
  }
}
