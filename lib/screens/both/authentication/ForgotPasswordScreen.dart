import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projectlight/components/ComponentsPackage.dart';
import 'package:projectlight/components/FormInputFieldWithIcon.dart';
import 'package:projectlight/components/IOSorAndroidComponents.dart';
import 'package:projectlight/tools/Firebase.dart';
import 'package:projectlight/tools/HTTPRequestHelper.dart';
import 'package:projectlight/validation/Validator.dart';

import 'LoginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String id = 'forgotPasswordScreen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _loading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = new TextEditingController();
  bool _successHideAndReplace = false;

  @override
  void dispose() {
    _email.dispose();
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
                          Center(
                              child: Text(
                            'Forgotten password',
                            style: GoogleFonts.lato(fontSize: 18),
                          )),
                          SizedBox(height: 10.0),
                          _successHideAndReplace
                              ? Text(
                                  'We have send a reset password send link to ${_email.text.trim()}. Please click the '
                                  'reset link to set a new password. \n\n'
                                  'Please check your inbox and spam')
                              : Text(
                                  "Dont't worry! Please enter the email you registered with us \n"
                                  "and we will send you reset password link."),

                          /// -- Email section --
                          _successHideAndReplace
                              ? SizedBox()
                              : FormInputFieldWithIcon(
                                  controller: _email,
                                  iconPrefix: Icons.email,
                                  labelText: 'Email',
                                  maxLength: 50,
                                  validator: Validator().email,
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (value) => null,
                                  onSaved: (value) => _email.text = value,
                                ),
                          SizedBox(
                            height: 5,
                          ),

                          /// -- Sign up button --
                          _successHideAndReplace
                              ? RaisedButton(
                                  color: Colors.blue,
                                  padding: EdgeInsets.all(22),
                                  child: Text(
                                    'Back to login',
                                    style: GoogleFonts.lato(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context, LoginScreen.id);
                                  })
                              : RaisedButton(
                                  color: Colors.blue,
                                  padding: EdgeInsets.all(22),
                                  child: Text(
                                    'SEND',
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
                                      String resetMessage =
                                          'Failed to send reset link, try again!';
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        _loading = true;
                                      });

                                      /// Login
                                      FirebaseTools firebase = FirebaseTools();
                                      String result =
                                          await firebase.resetPassword(
                                              email: _email.text.trim());
                                      if (result != null &&
                                          result.contains('Success')) {
                                        setState(() {
                                          _loading = false;
                                          _successHideAndReplace = true;
                                        });
                                        print('final result is $result');
                                      } else {
                                        /// Reset password failed
                                        setState(() {
                                          _loading = false;

                                          /// If google error
                                          if (firebase.error != null &&
                                              firebase.error.length > 0)
                                            resetMessage = firebase.error;
                                        });
                                        IOSorAndroidComponents()
                                            .alertWarningDialog(
                                                title: resetMessage,
                                                context: context);
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                content: Text(resetMessage)));
                                      }
                                    }
                                  }),
                          Divider(),
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
