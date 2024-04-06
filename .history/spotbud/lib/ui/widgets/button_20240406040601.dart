import 'package:flutter/material.dart';
import 'package:spotbud/ui/widgets/color_theme.dart';
import 'dart:math' as math;

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
  String? icon,
  double height = 170,
  double width = 170,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue, // You can adjust these colors as per your app's theme
            Colors.blueAccent,
          ],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Stack(
            children: [
              Center(
                child: icon != null
                    ? Image.asset(
                        icon!,
                        fit: BoxFit.cover,
                        height: 50, // Adjust the height as needed
                        width: 50,
                      )
                    : SizedBox(),
              ),
              CustomPaint(
                size: Size(width, height),
                painter: TextPathPainter(text),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class TextPathPainter extends CustomPainter {
  final String text;
  final double fontSize;
  final double radius;
  final double offset;
  final Paint _paint;

  TextPathPainter(
    this.text, {
    this.fontSize = 14,
    this.radius = 75,
    this.offset = 0,
  }) : _paint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill
          ..textAlign = TextAlign.center;

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    final textPath = Path();

    for (var i = 0; i < text.length; i++) {
      final angle = (i / (text.length - 1)) * math.pi;
      final x = (radius * math.cos(angle)) + (size.width / 2);
      final y = (radius * math.sin(angle)) + (size.height / 2) + offset;
      textPath
          .addRect(Rect.fromLTWH(x, y, 10, 10)); // Adjust rect size as needed
    }

    canvas.drawPath(textPath, _paint);
    canvas.drawPath(textPath, Paint()..color = Colors.black);
    canvas.drawTextAlongPath(TextSpan(style: textStyle, text: text), textPath,
        startOffset: 1.25);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
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
