import 'package:flutter/cupertino.dart';

class Height extends StatefulWidget {
  const Height({Key? key}) : super(key: key);

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  double feet = 0;
  double inches = 0;
  double meters = 0;
  double centimeters = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker.builder(
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                feet = (index + 1).toDouble();
                meters = feet * 0.3048;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Text('${index + 1} ft');
            },
            childCount: 10,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: CupertinoPicker.builder(
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                inches = (index + 1).toDouble();
                centimeters = inches * 2.54;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Text('${index + 1} in');
            },
            childCount: 12,
          ),
        ),
        SizedBox(width: 16),
        Text('${feet.round()} ft ${inches.round()} in'),
        SizedBox(width: 32),
        Text('${meters.floor()} m ${centimeters.floor()} cm'),
      ],
    );
  }
}
