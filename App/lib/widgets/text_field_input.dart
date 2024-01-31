import 'package:flutter/material.dart';

//text field input
//separate widget to support maintainability and reusability of code
//since we need text field inputs for both sign in and sign up

class TextFieldInput extends StatelessWidget { 
  final TextEditingController textEditingController;
  final is_password;
  final String hint_text;
  final TextInputType textInputType;

  const TextFieldInput({
    Key? key, 
    required this.textEditingController, 
    this.is_password = false, 
    required this.hint_text, 
    required this.textInputType
    }) : super(key:key);


  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
          borderSide: Divider.createBorderSide(context)
        );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint_text, //grab from constructor
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: is_password, //do not show input when input is password (obscured with stars)
    );
  }
}