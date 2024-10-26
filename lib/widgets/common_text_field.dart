import 'package:flutter/material.dart';

///for register and login

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;

  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final double borderRadius;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

///for edit profile page

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final TextStyle? labelStyle;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  const CommonTextField({
    Key? key,
    required this.controller,
    this.labelText,
    this.labelStyle,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = TextStyle(
      color: Colors.grey.shade400,
      fontSize: MediaQuery.of(context).size.width * 0.045,
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ?? defaultLabelStyle,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
