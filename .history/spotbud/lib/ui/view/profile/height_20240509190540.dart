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
  bool useFeetAndInches = true; // Track if feet and inches are selected

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CupertinoPicker.builder(
                  itemExtent: 32,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedFeet = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Text('${index + 1} ft');
                  },
                  childCount: 10, // Example: 10 feet
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CupertinoPicker.builder(
                  itemExtent: 32,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      selectedInches = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Text('${index + 1} in');
                  },
                  childCount: 12, // Example: 12 inches (0-11)
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 16),
          CupertinoSegmentedControl<bool>(
            children: {
              true: Text('Feet & Inches'),
              false: Text('Meters & Centimeters'),
            },
            groupValue: useFeetAndInches,
            onValueChanged: (value) {
              setState(() {
                useFeetAndInches = value!;
              });
            },
          ),
          SizedBox(height: 16),
          if (!useFeetAndInches)
            Row(
              children: [
                Expanded(
                  child: CupertinoPicker.builder(
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      // Handle meter selection
                    },
                    itemBuilder: (BuildContext context, int index) {
                      // Create items for meters (example: 10 meters)
                      return Text('${index + 1} m');
                    },
                    childCount: 10,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CupertinoPicker.builder(
                    itemExtent: 32,
                    onSelectedItemChanged: (index) {
                      // Handle centimeter selection
                    },
                    itemBuilder: (BuildContext context, int index) {
                      // Create items for centimeters (example: 100 cm)
                      return Text('${(index + 1) * 10} cm');
                    },
                    childCount: 10,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
