import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

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

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;

  const PasswordFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.validator,
  }) : super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
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
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    style: TextStyle(color: Colors.white),
                    obscureText: _obscureText,
                    validator: widget.validator,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.acccentColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 8), // Added space between input and error message
          if (widget.validator != null)
            Text(
              'This field is required.',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
