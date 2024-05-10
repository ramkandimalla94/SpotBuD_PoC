import 'package:flutter/material.dart';

class HeightSettingScreen extends StatefulWidget {
  @override
  _HeightSettingScreenState createState() => _HeightSettingScreenState();
}

class _HeightSettingScreenState extends State<HeightSettingScreen> {
  double _heightInFeet = 5;
  double _heightInInches = 0;
  double _heightInMeters = 1.52; // Default height in meters
  double _heightInCentimeters = 152; // Default height in centimeters
  bool _useFeetAndInches = true; // Default to using feet and inches

  @override
  Widget build(BuildContext context) {
    double heightInMeters = _heightInFeet * 0.3048 + _heightInInches * 0.0254;
    double heightInCentimeters = heightInMeters * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Set Height'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Height Unit:'),
                DropdownButton<bool>(
                  value: _useFeetAndInches,
                  onChanged: (bool? value) {
                    setState(() {
                      _useFeetAndInches = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem<bool>(
                      value: true,
                      child: Text('Feet & Inches'),
                    ),
                    DropdownMenuItem<bool>(
                      value: false,
                      child: Text('Meters & Centimeters'),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Height:'),
            _useFeetAndInches
                ? Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Feet'),
                          onChanged: (value) {
                            setState(() {
                              _heightInFeet = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Inches'),
                          onChanged: (value) {
                            setState(() {
                              _heightInInches = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preview:'),
                          Text(
                              '$heightInMeters meters $heightInCentimeters centimeters'),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Meters'),
                          onChanged: (value) {
                            setState(() {
                              _heightInMeters = double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Centimeters'),
                          onChanged: (value) {
                            setState(() {
                              _heightInCentimeters =
                                  double.tryParse(value) ?? 0;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preview:'),
                          Text('$_heightInFeet feet $_heightInInches inches'),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Process the height data here, you can save it or perform other actions
                // For example, print the selected height based on the unit
                if (_useFeetAndInches) {
                  print('Height: $_heightInFeet feet $_heightInInches inches');
                } else {
                  print(
                      'Height: $_heightInMeters meters $_heightInCentimeters centimeters');
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
