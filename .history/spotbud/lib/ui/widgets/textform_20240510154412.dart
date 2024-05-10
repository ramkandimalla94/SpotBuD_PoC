import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

Widget buildStyledInput({
  required TextEditingController controller,
  required ThemeData theme,
  String labelText = 'Email',
  String hintText = 'Enter your email',
  bool obscureText = false,
  IconData? prefixIcon,
  bool autofocus = false,
  String? Function(String?)? validator, // Validator function
  bool mandatory = true, // Optional parameter to mark field as mandatory
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText +
              (mandatory ? ' *' : ''), // Add asterisk for mandatory fields
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
              border: Border.all(
                color: theme.colorScheme.secondary, // Border color
                width: 1, // Border width
              ),
            ),
            child: TextFormField(
              // Changed from TextField to TextFormField
              controller: controller,
              style: TextStyle(color: theme.colorScheme.secondary),
              obscureText: obscureText,
              autofocus: autofocus,
              validator: validator, // Validator function added
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: theme.colorScheme.secondary.withOpacity(0.5)),
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, color: theme.colorScheme.primary)
                    : null,
                errorStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.red, // Changed error text color to red
                  fontWeight: FontWeight.bold, // Made error text bold
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
//shobhi1111cho@gmail.com