import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

Widget buildLoginButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = AppColors.acccentColor,
  Color primaryColor = Colors.blue,
  double textSize = 20,
  double height = 60,
  double width = 150,
  Color buttonColor = AppColors.acccentColor,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue[900]!;
          }
          return Colors.transparent;
        }),
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, AppColors.secondaryColor],
            stops: [0.5, 1.0],
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: textSize),
        ),
      ),
    ),
  );
}

// class CustomButton extends StatelessWidget {
//   final String text;
//   final String imagePath;
//   final Function onPressed;

//   const CustomButton({
//     Key key,
//     @required this.text,
//     @required this.imagePath,
//     @required this.onPressed,
//   }) : super(key: key);

Widget customhomebutton({
  required String text,
  required VoidCallback onPressed,
  required String imagePath,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 175,
      width: 400,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.centerLeft,
          radius: 1.5,
          colors: [
            AppColors.backgroundColor,
            Colors.blue,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
