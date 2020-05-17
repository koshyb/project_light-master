import 'package:email_validator/email_validator.dart';

import 'ProfanityChecker.dart';

class Validator {
  String email(String value) {
    if (!EmailValidator.validate(value.trim())) {
      return 'Invalid email entered';
    } else
      return null;
  }

  String password(String value) {
    Pattern pattern = r'^.{8,}$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim()))
      return 'Password should be minimum 8 characters';
    else
      return null;
  }

  String username(String value) {
//    Pattern length = r'^.{8,20}$';
    Pattern pattern = r"^[a-zA-Z]+(([_,.-][a-zA-Z0-9])?[a-zA-Z0-9]*)*$";
    RegExp regex = new RegExp(pattern);
//    RegExp lengthRegex = new RegExp(length);
    if (!regex.hasMatch(value.trim()))
      return 'Invalid username';
    else if (ProfanityChecker().isProfane(value))
      return 'Invalid username';
//    else if (!lengthRegex.hasMatch(value))
//      return 'Minimum 8 characters and maximum 20 characters';
    else
      return null;
  }

  String name(String value) {
    Pattern pattern = r"^[a-zA-Z]+(([_,.-][a-zA-Z])?[a-zA-Z]*)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim()))
      return 'Invalid character';
    else if (ProfanityChecker().isProfane(value))
      return 'Not valid';
    else
      return null;
  }

  String number(String value) {
    Pattern pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return value;
    else
      return null;
  }

  String amount(String value) {
    Pattern pattern = r'^\d+$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return value;
    else
      return null;
  }

  String notEmpty(String value) {
    Pattern pattern = r'^\S+$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return value;
    else
      return null;
  }
}
