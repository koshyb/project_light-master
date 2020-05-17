import 'package:flutter/material.dart';

class FormInputFieldWithIcon extends StatelessWidget {
  FormInputFieldWithIcon(
      {this.controller,
      this.iconPrefix,
      this.labelText,
      this.validator,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.minLines = 1,
      this.maxLines,
      this.onChanged,
      this.onSaved,
      this.maxLength,
      this.hint});

  final TextEditingController controller;
  final IconData iconPrefix;
  final String labelText;
  final String hint;
  final String Function(String) validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final void Function(String) onChanged;
  final void Function(String) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(
            iconPrefix,
            color: Colors.redAccent,
          ),
          labelText: labelText,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.black)),
      maxLength: maxLength,
      controller: controller,
      onSaved: onSaved,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
//      autovalidate: true,
    );
  }
}
