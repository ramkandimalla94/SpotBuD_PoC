import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Height extends StatefulWidget {
  const Height({Key? key}) : super(key: key);

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  int selectedFeet = 0;
  int selectedInches = 0;
  int selectedMeters = 0;
  int selectedCentimeters = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CupertinoPicker.builder(
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedFeet = index;
                selectedMeters =
                    (index * 30.48 ~/ 100).toInt(); // Convert feet to meters
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Text('${index + 1} ft');
            },
            childCount: 10,
          ),
        ),
        Divider(), // Add a divider between the two pickers
        Expanded(
          child: CupertinoPicker.builder(
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedInches = index;
                selectedCentimeters =
                    (index * 2.54).toInt(); // Convert inches to centimeters
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Text('${index + 1} in');
            },
            childCount: 12,
          ),
        ),
        Expanded(
          child: Container(), // Empty container for spacing
        ),
        Divider(), // Add a divider between the two pickers
        Expanded(
          child: CupertinoPicker.builder(
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedMeters = index;
                selectedFeet =
                    (index * 100 ~/ 30.48).toInt(); // Convert meters to feet
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Text('${index + 1} m');
            },
            childCount: 10,
          ),
        ),
        Divider(), // Add a divider between the two pickers
        Expanded(
          child: CupertinoPicker.builder(
            itemExtent: 32,
            onSelectedItemChanged: (index) {
              setState(() {
                selectedCentimeters = index;
                selectedInches =
                    (index / 2.54).toInt(); // Convert centimeters to inches
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return Text('${(index + 1) * 10} cm');
            },
            childCount: 10,
          ),
        ),
      ],
    );
  }
}
