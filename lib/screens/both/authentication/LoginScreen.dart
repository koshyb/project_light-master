import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projectlight/components/ComponentsPackage.dart';
import 'package:projectlight/components/FormInputFieldWithIcon.dart';
import 'package:projectlight/components/IOSorAndroidComponents.dart';
import 'package:projectlight/components/LogoHeader.dart';
import 'package:projectlight/screens/both/authentication/AuthorisationScreen.dart';
import 'package:projectlight/tools/Firebase.dart';
import 'package:projectlight/tools/HTTPRequestHelper.dart';
import 'package:projectlight/validation/Validator.dart';

import 'ForgotPasswordScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

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
                          /// -- LOGO --
                          LogoHeader(),
                          SizedBox(),
                          Center(
                              child: Text(
                            'Login',
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
                          FlatButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, ForgotPasswordScreen.id),
                              child: Text('Forgot password?')),
                          SizedBox(
                            height: 5,
                          ),

                          /// -- Sign up button --
                          RaisedButton(
                              color: Colors.redAccent,
                              padding: EdgeInsets.all(22),
                              child: Text(
                                'LOGIN',
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
                                      'Login failed, try again!';
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _loading = true;
                                  });

                                  /// Login
                                  FirebaseTools firebase = FirebaseTools();
                                  String result = await firebase.login(
                                      email: _email.text.trim(),
                                      password: _password.text.trim());
                                  if (result != null &&
                                      result.contains('Success')) {
                                    setState(() {
                                      _loading = false;
                                    });
//                                    print('final result is $result');
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        AuthorisationScreen.id, (r) => false);
                                  } else {
                                    /// Login failed
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
                                Navigator.pushNamed(context, RegisterScreen.id);
                              },
                              child: Text("Don't have a account? Register")),
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
}
