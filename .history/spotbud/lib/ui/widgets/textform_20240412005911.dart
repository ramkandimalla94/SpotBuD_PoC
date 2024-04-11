import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

Widget buildpassword({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData prefixIcon,
  bool autofocus = false,
  bool obscureText = false,
  required String? Function(String?) validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: Text(
            '*',
            style: TextStyle(color: Colors.red),
          ),
        ),
        autofocus: autofocus,
        obscureText: obscureText,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your password';
          } else if (value.length < 8) {
            return 'Password must be at least 8 characters long';
          } else if (!RegExp(
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
              .hasMatch(value)) {
            return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special symbol';
          }
          return validator(value);
        },
      ),
      SizedBox(height: 8),
      Text(
        'Password must: Be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number, and one special symbol.',
        style: TextStyle(color: Colors.grey),
      ),
    ],
  );
}

Widget buildStyledInput({
  required TextEditingController controller,
  String labelText = 'Email',
  String hintText = 'Enter your email',
  bool obscureText = false,
  IconData? prefixIcon,
  bool autofocus = false,
  String? Function(String?)? validator, // Validator function
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: AppColors.acccentColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            // Changed from TextField to TextFormField
            controller: controller,
            style: TextStyle(color: Colors.white),
            obscureText: obscureText,
            autofocus: autofocus,
            validator: validator, // Validator function added
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.acccentColor)
                  : null,
              errorStyle: TextStyle(
                  color: Colors.white), // Change validator text color to white
            ),
          ),
        ),
      ],
    ),
  );
}
