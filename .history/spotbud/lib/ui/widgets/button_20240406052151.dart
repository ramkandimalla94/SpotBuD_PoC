import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';

Widget buildLoginButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = AppColors.acccentColor,
  Color primaryColor = Colors.black,
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

Widget buildWorkoutButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = AppColors.acccentColor,
  Color primaryColor = AppColors.primaryColor,
  double textSize = 20,
  double height = 60,
  double width = 200,
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
          gradient: RadialGradient(
            radius: 9,
            center: Alignment.bottomRight,
            colors: [AppColors.primaryColor, AppColors.acccentColor],
            stops: [0.1, 1.0],
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
Widget customHomeButton({
  required String text,
  required VoidCallback onPressed,
  String? imagePath,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              AppColors.black,
              AppColors.secondaryColor,
            ],
          ),
        ),
        child: ListTile(
          leading: imagePath != null
              ? Image.asset(
                  imagePath,
                  color: AppColors.acccentColor,
                  height: 45,
                  width: 30,
                )
              : null,
          title: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget custombodybutton({
  required String text,
  required VoidCallback onPressed,
  required String imagePath,
  required VoidCallback onRemovePressed,
  double height = 200,
  double width = 175,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.black,
              ],
            ),
            borderRadius: BorderRadius.circular(25),
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
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: AppColors.acccentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: onRemovePressed,
            child: Container(
              width: 40,
              height: 40,
              child: Icon(
                Icons.clear,
                color: AppColors.backgroundColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

// CustomMachineButton widget
Widget CustomMachineButton({
  required String text,
  required VoidCallback onPressed,
  required VoidCallback onRemovePressed, // New parameter for removal
  required String imagePath,
  double height = 200,
  double width = 175,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 2,
              colors: [
                AppColors.acccentColor,
                AppColors.primaryColor,
              ],
            ),
            borderRadius: BorderRadius.circular(25),
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
                      padding: const EdgeInsets.only(left: 10),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: AppColors.backgroundColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: onRemovePressed,
            child: Container(
              width: 40,
              height: 40,
              child: Icon(
                Icons.clear,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
